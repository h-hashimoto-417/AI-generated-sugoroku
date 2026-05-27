require_relative "sample"

while true
    puts "遊ぶ人数を入力してね！(4人までにしてね)"

  player_count = gets.to_i

  if player_count > 4
    puts "ちゃんと文章を読もう！"
  else
    break
  end

  puts
end

player_info = Array.new(player_count+1) {{"name" => "hogehoge", "current_place" => 1, "state" => "no_goal", "place" => -1}}

for i in 1..player_count do
  puts "#{i}人目のプレイヤー情報を入力してね"

  print "名前："
  name = gets.chomp
  player_info[i]["name"] = name

end

# 順番決め.
player_order = [*1..player_count]
player_order.shuffle!

puts
puts "サイコロを振る順番は、以下のようになりました"
for i in 1..player_count do
  puts "#{i}番目：#{player_info[player_order[i-1]]["name"]}さん"
end
puts

puts "'#{$data_title}'を開始します！"

sugoroku_finished = false


turn_count = 1
p = 0
place = Array.new(player_count+1, 0)
def goal_judge(curr_place, cp, p)
  if(curr_place >= $data_count)
      puts "#{cp["name"]}さんはゴールしました！"
      cp["place"] = ++p
      cp["state"] = "finish"
    return true
  else
    return false
  end
end


while sugoroku_finished == false

  puts "------#{turn_count}ターン目------"
  for i in 1..player_count do
    curr_player = player_info[player_order[i-1]]

    if(curr_player["state"] == "finish")
      next
    end

    saikoro = rand(1..6)
    puts "#{curr_player["name"]}さんの出目は#{saikoro}でした！"

    if(saikoro+curr_player["current_place"] >= $data_count)
      puts "#{curr_player["name"]}さんはゴールしました！"
      p += 1
      curr_player["place"] = p
      curr_player["state"] = "finish"
      place[curr_player["place"]] = curr_player["name"]
    else  
      curr_player["current_place"] += saikoro
      puts "#{curr_player["name"]}さんは#{curr_player["current_place"]}マス目に到達しました"

      curr_p = $data_squares[curr_player["current_place"]-1]
      if(curr_p["effect"] != "move")
        puts "イベント発生！ #{curr_player["name"]}さんは#{curr_p["value"]}マス進んだ！"
        curr_player["current_place"] += curr_p["value"]

        if(saikoro+curr_player["current_place"] >= $data_count)
          puts "#{curr_player["name"]}さんはゴールしました！"
          p += 1
          curr_player["place"] = p
          curr_player["state"] = "finish"
          place[curr_player["place"]] = curr_player["name"]
        end
      end
    end

    puts

  end

  turn_count += 1
  sugoroku_finished = true
  for i in 1..player_count do
    if(player_info[i]["state"] != "finish")
      sugoroku_finished = false
    end
  end

  puts
end

puts "結果発表！"

for i in 1..player_count do
  puts "#{i}位：#{place[i]}さん！"
end
