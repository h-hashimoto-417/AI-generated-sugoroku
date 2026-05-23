# 仮実装

require "json"

def generate_sugoroku_map(theme)

    events = [
        "2マス進む",
        "１回休み",
        "3マス戻る",
        "サイコロをもう一回振る",
        "宝箱を見つける"
    ]

    random_squares = 3.times.map {events.sample}

    result =  {
        :title => "#{theme} スゴロク",
        :squares =>  [
        "スタート",
        "#{theme}について話す",
        *random_squares,
        "ゴール"
    ]
}

result

end

result = generate_sugoroku_map("旅行")

puts JSON.pretty_generate(result)