require "json"

class ApplicationController < ActionController::Base

  # jsonマップをデータベースに保存する関数.
  def save_map
    
    # このパスは実際に生成したものに置き換える.
    json_path = Rails.root.join("maps","samplemap.json")
    json_data = JSON.parse(File.read(json_path))

    # 新しいマップデータの作成.
    map = Map.create!(
      map_name: json_data["title"],
      num_of_squares: json_data["squares"].length
    )

    # マスのデータを作成. map_idは上で作成したマップに紐付けられている.
    json_data["squares"].each_with_index do |square, index|
      map.squares.create!(
        position: index+1,
        square_type: square["type"],
        square_text: square["text"],
        effect: square["effect"],
        value: square["value"]
      )
    end
  end

  # ゲームの初期化を行う関数.
  def init_game
    
    # 今までのゲームを全て消すもの.仕様によっては変更するかも.
    Game.destroy_all

    # マップのid. ユーザが選んだ(生成した)マップのidに置き換える.
    m_id = 1
    # プレイヤーの数. viewで入力されたものを受け取り置き換える.
    num_players = 1

    game = Game.create!(
      map_id: m_id,
      num_of_players: num_players,
      # ターンは0-based indexingで初期化.
      current_turn: 0
    )

    # プレイヤー名. UIからもらう.
    @names = Array.new(num_players)

    # プレイヤーの色. UIからもらう.
    @colors = Array.new(num_players)

    # 順番決め用の配列.
    @order = [*0..(num_players - 1)]
    @order.shuffle!

    @names.each_with_index do |name, index|
      u = User.find_by(uname: name)
      game.players.create!(
        pname: name,
        # ユーザDBに名前が存在するならそのまま使う?
        user_id: u ? u.uname : "guest", 
        curr_position: 0,
        ucolor: @colors[index],
        status: false,
        turn_skip: 0,
        turn_order: @order[index]
      )
    end
  end

  # サイコロを振る関数.
  def roll
    
  end

  # ゲーム終了処理をする関数.
  def end_sugoroku
    
  end
end
