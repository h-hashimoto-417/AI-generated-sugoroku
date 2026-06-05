require "json"
require "net/http"
require "uri"

class AiService
  def self.build_prompt(user_input)
    <<~TEXT
      あなたはスゴロクゲームの盤面を作成するAIです。

      ユーザーの希望:
      #{user_input}

      ユーザーの希望に合わせて、スゴロクのタイトルとマスの内容を作成してください。

      必ず以下のJSON形式だけで返してください。

      {
        "title": "スゴロクのタイトル",
        "squares": [
          {"type": "start", "text": "スタート", "effect": "none", "value": 0},
          {"type": "event", "text": "イベント内容", "effect": "move", "value": 2},
          {"type": "normal", "text": "何も起こらないマス", "effect": "none", "value": 0 },
          {"type": "event", "text": "イベント内容", "effect": "skip", "value": 1},
          {"type": "goal", "text": "ゴール", "effect": "finish", "value": 0}
        ]
      }

      effectには "none", "move", "skip", "roll_again", "finish" のいずれかを使ってください。
      valueは効果に応じた数値にしてください。
      "event"タイプのマスの間には、"normal"タイプのマスを最低1つ、最大4つまで入れてください。
      "event"タイプのマスのeffectは、"move", "skip", "roll_again"のいずれかを使用してください。
      "event"タイプのマスのeffectはが"move"のときは、valueは0以外の整数を指定し、textに何マス動くのかの指示を必ず入れてください。
      JSON以外の説明文は書かないでください。
    TEXT
  end

  def self.generate(user_input)
    api_key = ENV["GEMINI_API_KEY"]

    if api_key.nil? || api_key.empty?
      raise "GEMINI_API_KEYが設定されていません"
    end

    prompt = build_prompt(user_input)

    uri = URI("https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=#{api_key}")

    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"

    request.body = {
      contents: [
        {
          parts: [
            { text: prompt }
          ]
        }
      ]
    }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    data = JSON.parse(response.body)

    if data["error"]
      raise data["error"]["message"]
    end

    text = data["candidates"][0]["content"]["parts"][0]["text"]
    text = text.gsub(/```json|```/, "").strip

    JSON.parse(text)
  end
end