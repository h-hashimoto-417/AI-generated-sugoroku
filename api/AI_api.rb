# 仮実装

require "json"
require "net/http"
require "uri"

def build_prompt(user_input)
    prompt = <<~TEXT
        あなたはスゴロクゲームの盤面を作成するAIです

        ユーザーの希望:
        #{user_input}

        ユーザーの希望に合わせて、スゴロクのタイトルとマスの内容を作成してください

        必ず以下のJSON形式だけで返してください

        {
            "title" : "スゴロクのタイトル",
            "squares" : [
                {"type": "start", "text": "スタート", "effect": "none", "value": 0 },
                {"type": "event", "text": "イベント内容", "effect": "move", "value": 2 },
                {"type": "event", "text": "イベント内容", "effect": "skip", "value": 1 },
                {"type": "goal", "text": "ゴール", "effect": "finish", "value": 0 }
            ]
        }

        effectには "none", "move", "skip", "roll_again", "bonus", "finish" のいずれかを使ってください。
        valueは効果に応じた数値にしてください。
        JSON以外の説明文は書かないでください。
    TEXT

    prompt
end

def call_ai_api(prompt)
    api_key = ENV["GEMINI_API_KEY"]

    uri = URI("https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=#{api_key}")
    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"

    request.body = {
        :contents => [
            {
                :parts => [
                    {:text => prompt}
                ]
            }
        ]
    }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) do |http|
        http.request(request)
    end

    data = JSON.parse(response.body)

    usage = data["usageMetadata"]

    puts "===== Token Usage ====="
    puts "Prompt Tokens : #{usage["promptTokenCount"]}"
    puts "Output Tokens : #{usage["candidatesTokenCount"]}"
    puts "Total Tokens  : #{usage["totalTokenCount"]}"

    if usage["thoughtsTokenCount"]
        puts "Thought Tokens: #{usage["thoughtsTokenCount"]}"
    end

    puts "======================="

    if data["error"]
        puts "API error: "
        puts data["error"]["message"]
        exit
    end

    text = data["candidates"][0]["content"]["parts"][0]["text"]

    text = text.gsub(/```json|```/, "").strip

    JSON.parse(text)
end

puts "作りたいスゴロクのテーマを入力してください : "
user_input = gets.chomp

prompt = build_prompt(user_input)

result = call_ai_api(prompt)

puts JSON.pretty_generate(result)

File.write(
    "api/generated_map.json",
    JSON.pretty_generate(result)
)

puts "generated_map.jsonに保存しました"