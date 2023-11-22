class ScanService < ApplicationService
  def initialize
    @client = NlpService.client_setup
  end

  def all_scan
    pages = Page.where(is_scanned: false)
    total_count = pages.count
    pages.each_with_index do |page, i|
      p "#{i} / #{total_count}"
      results = validate(page.body)
      results.each do |result|
        sentence = result[:sentence]
        improvements = result[:improvements]
        scan(page, sentence, improvements)
      end
      page.is_scanned = true
      page.save!
    end
  end

  def validate(body)
    sentences = parse_sentences(body)
    results = []

    sentences.each do |sentence|
      improvements = NlpService.new(@client).validate(sentence)
      next if improvements.blank?
      results.push({sentence: sentence, improvements: improvements})
    end
    results
  end

  def parse_sentences(body)
    sentences = []
    doc = Nokogiri::HTML(body)
    ["h1", "h2", "h3", "p"].each do |tag|
      doc.css(tag).each do |node|
        text = node.text
        # 改行は句点に変換する
        text.gsub!("\n", "。")
        # 5文字以上の文字列のみを対象とする (文章として成立するものに限る)
        next if text.length < 5
        sentences.push(text)
      end
    end
    sentences
  end

  def scan(page, sentence, improvements)
    return if improvements.blank?
    improvements.each do |improvement|
      issue = page.issues.build
      issue.sentence = sentence
      issue.message = improvement.to_json
      issue.save!
    end
  end
end