require 'rails_helper'

RSpec.describe NewSiteService do
  describe 'new_pages' do
    before do
      @site = Site.create(url: 'https://wordrabbit.jp/')
      @body = ScrapingService.new.html(@site.url)
    end
    example 'test' do
      CrawlingService.new.new_pages(@site, @body)

      expect(Page.all.size > 0).to eq(true)
    end
  end

  describe 'crawling' do
    before do
      Site.create(url: 'https://wordrabbit.jp/')
    end
    example 'test' do
      limit = 1
      # テスト用に1ページのみクローリング
      CrawlingService.new.crawling(limit)
      page = Page.where(is_scraped: true).first
      expect(page.is_scanned).to eq(false)
      expect(page.is_scraped).to eq(true)
      expect(page.body.present?).to eq(true)
    end
  end
end