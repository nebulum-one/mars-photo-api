namespace :rovers do
  desc "Fetch latest Mars Rover images from NASA"
  task fetch_latest: :environment do
    puts "🚀 Starting Rover scrape..."
    PerseveranceScraper.new.scrape
    puts "✅ Perseverance scrape complete."

    CuriosityScraper.new.scrape
    puts "✅ Curiosity scrape complete."

    # Optional: Include older rovers if desired
    # OpportunitySpiritScraper.new("Opportunity").scrape
    # OpportunitySpiritScraper.new("Spirit").scrape

    puts "🪐 All scrapers finished."
  end
end
