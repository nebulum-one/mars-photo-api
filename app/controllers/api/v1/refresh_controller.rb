class Api::V1::RefreshController < ApplicationController
  def create
    PerseveranceScraper.new.scrape
    render json: { status: "ok", updated_at: Time.now }
  end
end
