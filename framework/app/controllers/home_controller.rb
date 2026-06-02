require "json"
require "net/http"
require "uri"
require_relative '../../../api/AI_api'

class HomeController < ApplicationController
  def top
  end
  
  def generate
    # ここでAIを呼び出して、すごろくの盤面とイベントを生成する処理を実装する
    # 例: ai_service = AIService.new; board, events = ai_service.generate_sugoroku
    # 生成した盤面とイベントをビューに渡す
    # render :top, locals: { board: board, events: events }
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

end
