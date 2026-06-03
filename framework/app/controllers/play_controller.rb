class PlayController < ApplicationController
    def top
    end
    def input_member
        @player_count = params[:player_count]
        @player_names = params[:player_names]
        # redirect_to play_path
    end

end
