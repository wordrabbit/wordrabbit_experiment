class NlpService < ApplicationService

  def initialize(client)
    @client = client
  end

  # ループを回す場合は、事前にclientを生成し、それを使い回すことで、TCP接続を都度作らずに実行できる
  def self.client_setup
    client = HTTPClient.new
    client.connect_timeout = 1
    client.send_timeout    = 1
    client.receive_timeout = 5
    client
  end

  def validate(text)
    return [] if text.blank?
    response = api_nlp(text)
    improvements = parse(response)
    return improvements
  end


  def parse(response)
    return [] if response.blank?
    response["improvements"]
  end

  def api_nlp(text)
    url = "http://localhost:5050/api/debug/validations/"
    body = { text: text }.to_json
    header = { 'Content-Type' => 'application/json' }
    res = @client.post(url, body: body, header: header)
    if res.status == 200
      JSON.parse res.body
    else
      { 'improvements': [] }
    end
  rescue => e
    { 'improvements': [] }
  end
end