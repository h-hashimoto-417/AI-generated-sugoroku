require "json"

def roll_dice
    rand(1..6)
end

def process_square(square, position, squares)
    puts "現在位置: #{position}"
    puts square["text"]

    skip_turn = 0

    if square["effect"] == "skip"
        skip_turn = square["value"]
    end

    position = apply_effect(square, position, squares)

    return position, skip_turn
end

def apply_effect(square, position, squares)
    if square["effect"] == "move"
        position += square["value"]
        position = 0 if position < 0
        position = squares.length - 1 if position >= squares.length
        puts "#{square["value"]}マス移動しました"

    elsif square["effect"] == "skip"
        puts "#{square["value"]}回休みです"

    # elsif square["effect"] == "bonus"
    #     puts "ボーナスを獲得しました"

    elsif square["effect"] == "finish"
        puts "ゴール！"
    end

    position
end

file_path = "api/generated_map.json"

unless File.exist?(file_path)
    puts "generated_map.jsonが見つかりません"
    puts "先に AI_api.rb を実行してマップを生成してください"
    exit
end

map_data = JSON.parse(File.read(file_path))

squares = map_data["squares"]
position = 0
skip_turn = 0

puts "タイトル: #{map_data["title"]}"
puts "ゲーム開始!"

while position < squares.length - 1
    if skip_turn > 0
        puts "\n#{skip_turn}回休み中です"
        skip_turn -= 1
        next
    end

    puts "\nEnterキーでサイコロを振る"
    gets
    
    dice = roll_dice
    puts "サイコロ: #{dice}"

    position += dice
    position = squares.length - 1 if position >= squares.length

    square = squares[position]

    position, new_skip_turn = process_square(square, position, squares)
    skip_turn = new_skip_turn if new_skip_turn > 0

    if square["effect"] == "roll_again"
        puts "もう一回サイコロを振れます"

        puts "\nEnterキーで追加のサイコロを振る"
        gets

        extra_dice = roll_dice
        puts "追加サイコロ: #{extra_dice}"
        
        position += extra_dice
        position = squares.length - 1 if position >= squares.length

        square = squares[position]

        position, new_skip_turn = process_square(square, position, squares)
        skip_turn = new_skip_turn if new_skip_turn > 0
    end
end

puts "\nゲーム終了!"