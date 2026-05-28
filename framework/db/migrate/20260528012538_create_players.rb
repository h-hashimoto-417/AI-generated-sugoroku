class CreatePlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :players do |t|
      t.references :game, null: false, foreign_key: true
      t.string :pname
      t.references :user, null: false, foreign_key: true
      t.integer :curr_position
      t.string :ucolor
      t.string :string
      t.boolean :status
      t.integer :turn_skip
      t.integer :turn_order

      t.timestamps
    end
  end
end
