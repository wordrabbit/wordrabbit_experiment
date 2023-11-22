require 'rails_helper'

RSpec.describe NewSiteService do
  describe 'create' do
    example 'test' do
      NewSiteService.new.call('https://wordrabbit.jp/')
      site = Site.all.first
      expect(site.url).to eq('https://wordrabbit.jp/')
    end
  end
end