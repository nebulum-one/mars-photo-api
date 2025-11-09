class Api::V1::RefreshController < ApplicationController
  def create
    results = []

    [
      { name: "Perseverance", scraper: PerseveranceScraper.new },
      { name: "Curiosity", scraper: CuriosityScraper.new }
    ].each do |rover|
      Rails.logger.info "🔄 Starting update for #{rover[:name]}..."

      before_count = rover[:scraper].rover.photos.count
      rover[:scraper].scrape
      after_count = rover[:scraper].rover.photos.count

      new_photos = after_count - before_count
      Rails.logger.info "✅ Added #{new_photos} new photos for #{rover[:name]} (total now #{after_count})."

      results << {
        rover: rover[:name],
        new_photos: new_photos,
        total_photos: after_count
      }
    end

    render json: {
      status: "ok",
      updated_at: Time.current,
      results: results
    }
  end
end
