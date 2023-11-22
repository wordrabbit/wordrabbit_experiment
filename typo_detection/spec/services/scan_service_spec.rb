require 'rails_helper'

RSpec.describe ScanService do
  describe 'all_scan' do
    before do
      site = Site.create!(url: 'https://wordrabbit.jp/')
      body = "<p>父がカレーに食べた。</p>"
      @page = Page.create!(site_id: site.id, url: 'https://wordrabbit.jp/', body: body, is_scanned: false)
    end
    example 'test' do
      ScanService.new.all_scan
      @page.reload
      expect(@page.is_scanned).to eq(true)
      expect(Issue.all.size > 0).to eq(true)
    end
  end

  describe 'validate' do
    before do
      @body = "<p>父がカレーに食べた。</p>"
    end
    example 'test' do
      results = ScanService.new.validate(@body)
      expect(results.size > 0).to eq(true)
    end
  end

  describe 'scan' do
    before do
      @sentence = "父がカレーに食べた。"
      @improvement = JSON.parse({ 'code': 'SAMPLE', 'target_word': 'に', 'replace_to': 'を' }.to_json)
      site = Site.create!(url: 'https://wordrabbit.jp/')
      @page = Page.create!(site_id: site.id, url: 'https://wordrabbit.jp/')
    end
    example 'test' do
      ScanService.new.scan(@page, @sentence, [@improvement])
      issue = Issue.all.first
      expect(issue.sentence).to eq(@sentence)
      expect(issue.message).to eq("{\"code\":\"SAMPLE\",\"target_word\":\"に\",\"replace_to\":\"を\"}")
    end
  end
end

