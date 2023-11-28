class CrawlingService < ApplicationService
  def initialize
  end

  def crawling(limit = nil)
    Site.all.each do |site|
      # まず全てのpageを未取得のステータスに変更する
      site.pages.each do |page|
        page.update(is_scraped: false)
      end

      # トップページからリンクが張られているURLを記録する
      top_body = ScrapingService.new.html(site.url)
      new_pages(site, top_body)

      # 未クローリングのページがなくなるまで繰り返す
      crawl_count = 0
      while true
        break if limit && crawl_count >= limit
        pages = site.pages.where(is_scraped: false)
        p "未取得のページ数: #{pages.count}"
        break if pages.blank?

        page = pages.first
        # HTMLを取得する (page.urlは相対パスになっているので、絶対パスでアクセスする)
        page_body = ScrapingService.new.html(site.url + page.url)
        # 新たにリンクを検出する
        new_pages(site, page_body)
        # page_bodyを保存する
        if page.body != page_body
          page.body = page_body
          # もう一度スクレイピングしないように、アラート検知を実行できるように、フラグを変更する
          page.is_scraped = true
          page.is_scanned = false
          page.save!
        else
          page.is_scraped = true
          page.save!
        end
        crawl_count += 1

        sleep 2
      end
    end
  end

  # htnmlを解析して、新しいページがあれば保存する
  def new_pages(site, body)
    doc = Nokogiri::HTML(body)
    ahrefs = doc.css('a')
    ahrefs.each do |ahref|
      url = ahref.attr("href")
      next if url.blank?
      url = url.gsub(site.url, "/")

      # 同じドメイン内のみを対象とする
      next if url[0] != "/"
      # トップページも不要
      next if url == "/"
      # すでに保存されているページは不要
      next if Page.where(url: url).present?
      # 新規で作成する
      page = site.pages.build
      page.url = url
      page.save!
    end
  end
end