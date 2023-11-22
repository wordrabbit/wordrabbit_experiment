require 'rails_helper'

RSpec.describe NewSiteService do
  describe 'create' do
    before do
      site = Site.create!(url: 'https://wordrabbit.jp/')
      page = Page.create!(site_id: site.id, url: 'https://wordrabbit.jp/sample', body: '<p>カレーに食べたい</p>')
      message = {'code': 'PARTICLE_INCORRECT', 'target_word': 'に', 'replace_to': 'を', 'index_char_end': 3}
      Issue.create!(page_id: page.id, message: message.to_json, sentence: 'カレーに食べたい')
    end
    example 'test' do
      DisplayAlertService.new.index
    end
  end
end