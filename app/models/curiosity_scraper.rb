class CuriosityScraper
  require "open-uri"
  require "json"
  BASE_URL = "https://mars.nasa.gov/api/v1/raw_image_items/"

  attr_reader :rover

  def initialize
    @rover = Rover.find_by(name: "Curiosity")
  end

  def scrape
    puts "🚀 Starting scrape for Curiosity..."
    create_photos
    latest_photo = rover.photos.order(created_at: :desc).first
    if latest_photo
      puts "🛰️ Latest Curiosity photo → Sol #{latest_photo.sol}, Earth date #{latest_photo.created_at}, Camera #{latest_photo.camera.name}"
    end
    puts "✅ Finished scraping Curiosity."
  end

  def collect_links
    begin
      response = JSON.parse(URI.open("#{BASE_URL}?order=sol%20desc,instrument_sort%20asc,sample_type_sort%20asc,%20date_taken%20desc&per_page=1&page=0&condition_1=msl:mission").read)
      latest_item = response["items"]&.first
      unless latest_item
        puts "⚠️ No items returned from NASA for Curiosity."
        return []
      end

      latest_sol_available = latest_item["sol"].to_i
      latest_sol_scraped = rover.photos.maximum(:sol).to_i

      puts "📡 Curiosity → Latest sol available: #{latest_sol_available}, last scraped sol: #{latest_sol_scraped}"

      if latest_sol_available <= latest_sol_scraped
        puts "✅ No new sols to scrape for Curiosity."
        return []
      end

      sols_to_scrape = ((latest_sol_scraped + 1)..latest_sol_available).to_a
      puts "🪐 Scraping new sols: #{sols_to_scrape.join(', ')}"

      sols_to_scrape.map do |sol|
        "#{BASE_URL}?order=sol%20desc,instrument_sort%20asc,sample_type_sort%20asc,%20date_taken%20desc&per_page=200&page=0&condition_1=msl:mission&condition_2=#{sol}:sol:in"
      end
    rescue StandardError => e
      puts "❌ Error in collect_links: #{e.message}"
      []
    end
  end

  private

  def create_photos
    collected = collect_links
    if collected.empty?
      puts "⚠️ No new sols detected, skipping photo creation."
      return
    end

    collected.each { |url| scrape_photo_page(url) }
  end

  def scrape_photo_page(url)
    begin
      response = JSON.parse(URI.open(url).read)
      sol = response["items"].first["sol"] rescue nil
      puts "🧩 Processing sol #{sol} (#{response['items'].size} items)..." if sol

      response["items"].each do |image|
        next unless image["https_url"]

        # Accept both full and subframe images
        sample_type = image.dig("extended", "sample_type")
        next unless %w[full subframe].include?(sample_type)

        create_photo(image)
      end
    rescue OpenURI::HTTPError => e
      puts "HTTP error occurred: #{e.message} for URL: #{url}. Skipping."
    rescue StandardError => e
      puts "Error occurred: #{e.message} for URL: #{url}. Skipping."
    end
  end

  def create_photo(image)
    sol = image["sol"]
    earth_date = image["date_taken"]
    camera = camera_from_json(image)
    link = image["https_url"]

    if camera.is_a?(String)
      puts "⚠️ Camera not found: #{camera}"
      return
    end

    photo = Photo.find_or_initialize_by(sol: sol, camera: camera, img_src: link, rover: rover)
    if photo.new_record?
      photo.log_and_save_if_new
      puts "🪐 Added → Sol #{sol}, Earth date #{earth_date}, Camera #{camera.name}"
    end
  rescue => e
    puts "❌ Error creating photo for sol #{sol}: #{e.message}"
  end

  def camera_from_json(image)
    camera_name = image["instrument"]
    camera = rover.cameras.find_by(name: camera_name) || rover.cameras.find_by(full_name: camera_name)

    if camera.nil?
      puts "⚙️ Adding new camera: #{camera_name}"
      camera = rover.cameras.create(name: camera_name, full_name: camera_name)
      puts(camera.persisted? ? "✅ Camera added: #{camera_name}" : "❌ Failed to add camera: #{camera_name}")
    end

    camera
  end
end
