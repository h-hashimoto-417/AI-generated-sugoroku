# 仮実装

require "json"

def generate_sugoroku_map(theme)

    events = [
        {:type => "event", :text => "2マス進む", :effect => "move", :value => 2},
        {:type => "event", :text => "１回休み", :effect => "skip", :value => 1},
        {:type => "event", :text => "3マス戻る", :effect => "move", :value => -3},
        {:type => "event", :text => "サイコロをもう一回振る", :effect => "roll_again", :value => 1},
        {:type => "event", :text => "宝箱を見つける", :effect => "bonus", :value => 1}
    ]

    random_squares = 3.times.map {events.sample}

    result =  {
        :title => "#{theme} スゴロク",
        :squares =>  [
       {:type => "start", :text => "スタート", :effect => "none", :value => 0},
       {:type => "normal", :text => "#{theme}について話す", :effect => "none", :value => 0},
       *random_squares,
       {:type => "goal", :text => "ゴール", :effect => "finish", :value => 0}     
    ]
}

result

end

puts "作りたいスゴロクのテーマを入力してください : "
theme = gets.chomp

result = generate_sugoroku_map(theme)

puts JSON.pretty_generate(result)