class DisplayAlertService < ApplicationService
  def initialize
  end

  # bundle exec rails runner -e development "DisplayAlertService.new.index"
  def index
    Issue.all.each do |issue|
      # ダンプしたimprovementを復元する
      improvement = JSON.parse(issue.message)

      code = improvement["code"]
      # 以下の3つの修正だけ表示します。
      permits = [
        "PARTICLE_INCORRECT", # 助詞の誤り
        "INCORRECT_TYPO", # 誤字
        "GRAMMAR_TARI" # たり抜け
      ]
      next unless permits.include?(code)


      # 修正箇所をハイライトする
      page = issue.page
      sentence = issue.sentence
      target_word = improvement["target_word"]
      replace_to = improvement["replace_to"]
      index_char_end = improvement["index_char_end"]
      pre_text = sentence[0..index_char_end]
      post_text = sentence[(index_char_end + 1)..-1]

      p "-------------------------"
      p page.url
      p pre_text + "[ALERT]" + post_text
      p "target_word: #{target_word}, replace_to: #{replace_to}"
    end
    true
  end
end
