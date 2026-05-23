# 仮実装

require "json"

def generate_sugoroku_map(theme)
  {
    title: "#{theme} スゴロク",
    squares: [
      "スタート",
      "#{theme}について話す",
      "2マス進む",
      "1回休み",
      "ゴール"
    ]
  }
end

result = generate_sugoroku_map("旅行")

puts JSON.pretty_generate(result)