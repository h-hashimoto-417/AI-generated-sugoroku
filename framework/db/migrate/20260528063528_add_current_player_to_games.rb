class AddCurrentPlayerToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :current_player, :integer
  end
end
