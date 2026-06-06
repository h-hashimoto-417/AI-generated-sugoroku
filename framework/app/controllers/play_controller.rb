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
    else
        json_path = Rails.root.join("maps","samplemap.json")
        json_data = JSON.parse(File.read(json_path))
        @sugoroku = json_data
    end
  end

  def input_member
    session[:player_count] = params[:player_count].to_i
    session[:player_names] = params[:player_names]
    session[:player_colors] = params[:player_colors]
    puts "プレイヤーの人数：#{session[:player_count]}"
    # gameの初期化もここでする
    redirect_to "/play"
  end

  def play
    # 1. セッションからプレイヤー人数を復元してViewに渡す
    @player_count = session[:player_count] || 2 # 万が一空っぽなら2人にする
    @player_names = session[:player_names]
    @player_colors = session[:player_colors]
    puts "プレイヤーの名前: #{@player_names}"
    puts "プレイヤーの選択した色: #{@player_colors}"

    # 2. スゴロクのマップデータも play 画面用にここで読み込んでViewに渡す！
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
    else
        json_path = Rails.root.join("maps","samplemap.json")
        json_data = JSON.parse(File.read(json_path))
        @sugoroku = json_data
    end

  end

  def sugoroku
    # さいころとプレイヤーの場所、ターンの制御を行う
    
  end

  def current_player
  render json: {
    player_name: Player.current.name
  }
  end

end