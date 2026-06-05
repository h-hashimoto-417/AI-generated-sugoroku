class HomeController < ApplicationController
  def top
  end

  def generate
    prompt = params[:prompt]

    # テスト用: プロンプトが空の場合はサンプルマップを表示
    if prompt.blank?
      json_path = Rails.root.join("maps","samplemap.json")
      json_data = JSON.parse(File.read(json_path))
      @sugoroku = json_data
      return
    end

    result = AiService.generate(prompt)
    puts JSON.pretty_generate(result)


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

end