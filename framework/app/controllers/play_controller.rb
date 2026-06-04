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
  end


end