class HomeController < ApplicationController
  def top
  end
  
  def generate
    # ここでAIを呼び出して、すごろくの盤面とイベントを生成する処理を実装する
    # 例: ai_service = AIService.new; board, events = ai_service.generate_sugoroku
    # 生成した盤面とイベントをビューに渡す
    # render :top, locals: { board: board, events: events }
    prompt = params[:prompt]
    puts "GENERATE ACTION CALLED"
    #render :generate
    #redirect_to("/home/show_result")
  end

  def show_result
    # ここで生成された盤面とイベントを表示する処理を実装する
    # 例: @board = params[:board]; @events = params[:events]
  end
end
