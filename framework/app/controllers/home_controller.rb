class HomeController < ApplicationController
  def top
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

    render :generate

  rescue => e
    Rails.logger.error("AI生成エラー")
    Rails.logger.error(e.message)

    @sugoroku = {
      "title" => "エラー",
      "squares" => []
    }

    render :generate
  end

  def save_map
    map_data = params[:map_data]
    # ここでmap_dataをデータベースに保存する処理を実装する
    # 例: Map.create(data: map_data)
    head :ok
  end
end