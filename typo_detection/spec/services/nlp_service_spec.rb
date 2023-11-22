require 'rails_helper'

RSpec.describe NlpService do
  describe 'validate' do
    before do
      @client = NlpService.client_setup
    end
    example 'test' do
      improvements = NlpService.new(@client).validate('父がカレーに食べた。')
      improvement = improvements[0]
      expect(improvement['index_char_start']).to eq(5) # 5文字目にエラーがある
      expect(improvement['target_word']).to eq('に') # 「に」がエラーである
      expect(improvement['replace_to']).to eq('を') # 「を」に置き換えるように提案されている
    end
  end
end