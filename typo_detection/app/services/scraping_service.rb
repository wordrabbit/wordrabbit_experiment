class ScrapingService < ApplicationService
  require 'nkf'
  require 'open-uri'

  def initialize
  end

  # htmlデータを取得する
  def html(url, url_encode=true)
    return nil if url.blank?
    if url_encode
      # 一度binaryでそのまま読み、推測通りに変換する
      # ://がエンコードされていると読み取れないので置換
      url = URI.encode_www_form_component(url)
      url.gsub!("%3A%2F%2F", '://')
      url.gsub!("%3F", '?')
      url.gsub!("%2F", '/')
      url.gsub!("%3D", '=')
    end
    io = OpenURI.open_uri(url, "r:binary")
    read_uri = io.base_uri
    response = io.read
    # 推測した文字コードに一度変換する
    enc = NKF.guess(response)
    response.force_encoding(enc)
    # そこからUTF8に変換する
    res = response.encode('utf-8', invalid: :replace, undef: :replace)
    res
  rescue => e
    return nil
  end
end
