class AdminController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def trigger_scrapers
    if params[:secret] == ENV['SCRAPER_SECRET']
      run_scrapers
      render json: { 
        status: 'success', 
        message: 'Scrapers started', 
        timestamp: Time.now 
      }
    else
      render json: { 
        status: 'error', 
        message: 'Unauthorized' 
      }, status: :unauthorized
    end
  end
  
  private
  
  def run_scrapers
    Thread.new do
      begin
        Rails.logger.info "Starting scrapers at #{Time.now}"
        
        PerseveranceScraper.new.scrape
        Rails.logger.info "Perseverance complete"
        
        CuriosityScraper.new.scrape
        Rails.logger.info "Curiosity complete"
        
        OpportunitySpiritScraper.new("Opportunity").scrape
        Rails.logger.info "Opportunity complete"
        
        OpportunitySpiritScraper.new("Spirit").scrape
        Rails.logger.info "Spirit complete"
        
        Rails.logger.info "All scrapers completed at #{Time.now}"
      rescue => e
        Rails.logger.error "Scraper error: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
      end
    end
  end
end
