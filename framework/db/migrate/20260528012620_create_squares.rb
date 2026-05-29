class CreateSquares < ActiveRecord::Migration[7.1]
  def change
    create_table :squares do |t|
      t.references :map, null: false, foreign_key: true
      t.integer :position
      t.string :square_type
      t.string :square_text
      t.string :effect
      t.integer :value

      t.timestamps
    end
  end
end
