class NewSiteService < ApplicationService
  def initialize
  end

  def call(url)
    site = Site.new(url: url)
    return site unless site.valid?

    ActiveRecord::Base.transaction do
      site.save!
    end
    site
  end
end