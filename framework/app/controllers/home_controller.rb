require "json"
require "net/http"
require "uri"
require_relative '../../../api/AI_api'


class HomeController < ApplicationController
  def top
  end

  
  def generate_original
    # ここでAIを呼び出して、すごろくの盤面とイベントを生成する処理を実装する
    # 生成した盤面とイベントをビューに渡す
    user_input = params[:prompt]
    puts "promptに代入"
    prompt = build_prompt(user_input)
    puts "promptに代入しました"
    results = call_ai_api(prompt)

    @sugoroku = results
    puts JSON.pretty_generate(results)
    #render :generate
    #redirect_to("/home/show_result")
  end

  def save_map
    map_data = params[:map_data]
    # ここでmap_dataをデータベースに保存する処理を実装する
    # 例: Map.create(data: map_data)
    head :ok
  end

  def generate
    prompt = params[:prompt]

    result = AiService.generate(prompt)

    map = Map.create!(
      map_name: result["title"],
      num_of_squares: result["squares"].length
    )

    session[:map_id] = map.id

    result["squares"].each_with_index do |square, index|
      map.squares.create!(
        position: index + 1,
        square_type: square["type"],
        square_text: square["text"],
        effect: square["effect"],
        value: square["value"]
      )
    end

    Rails.logger.info("AI生成成功")
    Rails.logger.info(result.inspect)

    @sugoroku = result

    @log = "AI生成成功: #{map.map_name}"

    render :generate

  rescue => e
    Rails.logger.error("AI生成エラー")
    Rails.logger.error(e.message)

    @log = "エラー: #{e.message}"

    render :generate
  end
end

