class PlayController < ApplicationController
  def top
    if session[:map_id]
      @map = Map.find_by(id: session[:map_id])

      if @map
        @sugoroku = {
          "title" => @map.map_name,
          "squares" => @map.squares.order(:position).map do |square|
            {
              "type" => square.square_type,
              "text" => square.square_text,
              "effect" => square.effect,
              "value" => square.value
            }
          end
        }
      end
    end
  end

  def input_member
    player_count = params[:player_count].to_i
    for i in 1..player_count
        Player.create!(
            game_id: 1, # 仮のゲームID、実際には適切なゲームIDを設定する必要があります
            user_id: i # 仮のユーザーID、実際には適切なユーザーIDを設定する必要があります
            player_name: "Player #{i}" # 仮のプレイヤー名、実際にはユーザーから入力を受け取るなどして設定する必要があります
        )
        end
  end


end