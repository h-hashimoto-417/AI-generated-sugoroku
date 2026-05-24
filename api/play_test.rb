require "json"

map_data = JSON.parse(File.read("api/generated_map.json"))

squares = map_data["squares"]
position = 0

puts "タイトル: #{map_data["title"]}"
puts "ゲーム開始!"

while position < squares.length - 1
    puts "\nEnterキーでサイコロを振る"
    gets
    
    dice = rand(1..6)
    puts "サイコロ: #{dice}"

    position += dice
    position = squares.length - 1 if position >= squares.length

    square = squares[position]

    puts "現在位置: #{position}"
    puts square["text"]

    if square["effect"] == "move"
        position += square["value"]
        position = 0 if position < 0
        position = squares.length - 1 if position >= squares.length
        puts "#{square["value"]}マス移動しました"
    elsif square["effect"] == "skip"
        puts "#{square["value"]}回休みです"
    elsif square["effect"] == "roll_again"
        puts "もう一回サイコロを振れます"
    elsif square["effect"] == "bonus"
        puts "ボーナスを獲得しました"
    elsif square["effect"] == "finish"
        puts "ゴール！"
    end
end

puts "\nゲーム終了!"