# 仮実装

require "json"

def build_prompt(user_input)
    prompt = <<~TEXT
        あなたはスゴロクゲームの盤面を作成するAIです

        ユーザーの希望:
        #{user_input}

        ユーザーの希望に合わせて、スゴロクのタイトルとマスの内容を作成してください

        必ず以下のJSON形式だけで返してください

        {
            "title" : "スゴロクのタイトル”,
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
    # TODO : 使用するAIのAPIが決まったらここに接続処理を書く
    # ex : OPENAI, Claude, Gemini, Difyなど

    # 仮の返答
    return {
        :title => "仮の返答"
        :square => []
    }
end

puts "作りたいスゴロクのテーマを入力してください : "
user_input = gets.chomp

prompt = build_prompt(user_input)

puts prompt
