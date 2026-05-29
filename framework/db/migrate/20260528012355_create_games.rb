class CreateGames < ActiveRecord::Migration[7.1]
  def change
    create_table :games do |t|
      t.references :map, null: false, foreign_key: true
      t.integer :num_of_players
      t.integer :current_turn

      t.timestamps
    end
  end
end
