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

    # マップのid. ユーザが選んだ(生成した)マップのidに置き換える.
    @m_id = 1
    # プレイヤーの数. viewで入力されたものを受け取り置き換える.
    @num_players = 1
    #ゲームモード. どこかからもらってくる.
    @game_mode = 0

    game = Game.create!(
      map_id: @m_id,
      num_of_players: @num_players,
      current_turn: 1,
      # 0 -> 進行中.
      game_status: 0,
      # プレイヤーのオーダーは0-based indexingで初期化.
      current_player: 0,
      mode: @game_mode
    )

    # プレイヤー名. UIからもらう.
    # もし、ログイン済のプレイヤーがいるなら、その人はユーザDBの方からnameを入れる.
    @names = Array.new(@num_players)

    # プレイヤーの色. UIからもらう.
    @colors = Array.new(@num_players)

    # 順番決め用の配列.
    @order = [*0..(@num_players - 1)]
    @order.shuffle!

    # プレイヤー登録.
    @names.each_with_index do |name, index|
      u = User.find_by(uname: name)

      # 全員がログインしていない場合.
      if @game_mode == 0

        game.players.create!(
          pname: name,
          user_id: nil, 
          curr_position: 0,
          ucolor: @colors[index],
          status: false,
          turn_skip: 0,
          turn_order: @order[index]
        )

      elsif @game_mode == 1

        # マップ作成者だけ(プレイヤー1)がログインしている場合.
        game.players.create!(
        pname: (index == 0) ? u&.uname : name,
        user_id: (index == 0) ? u&.id : nil, 
        curr_position: 0,
        ucolor: @colors[index],
        status: false,
        turn_skip: 0,
        turn_order: @order[index]
        )

      else

        # 全員がログインしている場合.
        game.players.create!(
        pname: u&.uname || name, # ユーザーが見つからない場合は入力された名前をフォールバックとして使用
        user_id: u&.id, 
        curr_position: 0,
        ucolor: @colors[index],
        status: false,
        turn_skip: 0,
        turn_order: @order[index]
        )

      end
      
    end
  end

  # ターンの進行を行う関数.
  def manage_turn

    # gameidは進行中のidを何らかの形で受け取る.
    @game = Game.find(params[:id])
    @players = @game.players
    @current_player = @game.players.find_by(turn_order: @game.current_player)

    # もし全員がゴールしているなら終了処理へ.
    if @players.all?(&:status)
      sugoroku_end
      return
    end

    # そのプレイヤーがまだゴールしていない場合.
    if @current_player.status == false
      if @current_player.turn_skip > 0
      #次の番のプレイヤーが休みの時.
      @current_player.turn_skip -= 1
      @current_player.save!
      else
        roll
      end
    else

    end

    # 次のプレイヤー(加算して、最大人数でmodを取る)
    @game.current_player = (@game.current_player + 1) % @game.num_of_players
    @game.current_turn += 1

    @game.save!
    
  end

  # サイコロを振る関数.目の決定とマスの移動を別にしたいならすることも可能(だと思います)
  def roll

    # gameidは進行中のidを何らかの形で受け取る.
    @game = Game.find(params[:id])
    @map = Map.find_by(id: @game.map_id)

    @current_player = @game.players.find_by(turn_order: @game.current_player)

    # さいころ.
    @dice = rand(1..6)

    @new_position = @current_player.curr_position + @dice
    # num_of_squaresは0-based indexing.
    if @new_position >= @map.num_of_squares
      @new_position = @map.num_of_squares - 1
    end

    # 止まったマスの効果処理. move, roll_againに関しては、再度止まったマスの効果は発動しないことにしています.
    # 再帰的に書けばできるはずですが, ひとまずは楽な方で......
    @new_square = @map.squares.find_by(position: @new_position)
    case @new_square.square_type
    when "skip" then
      @current_player.turn_skip = @new_square.value
    when "move" then
      @new_position = @current_player.curr_position + @new_square.value
      if @new_position >= @map.num_of_squares
        @new_position = @map.num_of_squares - 1
      end
    when "roll_again" then
      @second_dice = rand(1..6)
      @new_position += @second_dice

      if @new_position >= @map.num_of_squares
        @new_position = @map.num_of_squares - 1
      end
    end

    # これ以上マスの動きはないので反映.
    @current_player.curr_position = @new_position

    # ゴールした場合
    @new_square = @map.squares.find_by(position: @new_position)
    if @new_square.square_type == "finish"
      @current_player.status = true
    end

    @current_player.save!

  end

  # ゲーム終了処理をする関数.
  def sugoroku_end
    # gameidは進行中のidを何らかの形で受け取る.
    @game = Game.find(params[:id])

    # もし、プレイ履歴などを後から見返せるようにするなら、以下の処理だけでOKなはずです(というかdestroyしちゃ駄目)
    @game.game_status = 1
    @game.save!

    # それが要らないというなら、以下のようにdestroyでいいはず
    # @game.destroy_all

  end
end
