# class HomeController < ApplicationController
#   def top
#   end
  
#   def generate
#     # ここでAIを呼び出して、すごろくの盤面とイベントを生成する処理を実装する
#     # 例: ai_service = AIService.new; board, events = ai_service.generate_sugoroku
#     # 生成した盤面とイベントをビューに渡す
#     # render :top, locals: { board: board, events: events }
#     prompt = params[:prompt]
#     puts "GENERATE ACTION CALLED"
#     #render :generate
#     #redirect_to("/home/show_result")
#   end

# end

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

    @sugoroku = "AI生成成功: #{map.map_name}"

    render :generate

  rescue => e
    Rails.logger.error("AI生成エラー")
    Rails.logger.error(e.message)

    @sugoroku = "エラー: #{e.message}"

    render :generate
  end
end