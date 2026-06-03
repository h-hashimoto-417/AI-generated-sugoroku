class PlayController < ApplicationController
  def top
    if session[:map_id]
      @map = Map.find_by(id: session[:map_id])
      @squares = @map&.squares&.order(:position)
    end
  end

  def input_member
  end
end