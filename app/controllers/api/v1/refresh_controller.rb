class Api::V1::RefreshController < ApplicationController
  def create
    results = []

    [
      { name: "Perseverance", scraper: PerseveranceScraper.new },
      { name: "Curiosity", scraper: CuriosityScraper.new }
    ].each do |rover|
      Rails.logger.info "🔄 Starting update for #{rover[:name]}..."

      start_time = Time.current
      before_count = rover[:scraper].rover.photos.count

      begin
        rover[:scraper].scrape
      rescue => e
        Rails.logger.error "❌ Error scraping #{rover[:name]}: #{e.message}"
        results << {
          rover: rover[:name],
          status: "error",
          message: e.message
        }
        next
      end

      after_count = rover[:scraper].rover.photos.count
      new_photos = after_count - before_count
      duration = (Time.current - start_time).round(2)

      # Find newest photo metadata
      last_photo = rover[:scraper].rover.photos.order(sol: :desc).first
      latest_sol = last_photo&.sol
      latest_earth_date = last_photo&.earth_date

      Rails.logger.info "✅ Added #{new_photos} new photos for #{rover[:name]} (latest sol #{latest_sol}, Earth date #{latest_earth_date}). Took #{duration}s."

      results << {
        rover: rover[:name],
        new_photos: new_photos,
        total_photos: after_count,
        latest_sol: latest_sol,
        latest_earth_date: latest_earth_date,
        duration_seconds: duration
      }
    end

    render json: {
      status: "ok",
      updated_at: Time.current,
      results: results
    }
  end
end
