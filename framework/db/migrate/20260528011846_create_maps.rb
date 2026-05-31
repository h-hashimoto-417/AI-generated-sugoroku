class CreateMaps < ActiveRecord::Migration[7.1]
  def change
    create_table :maps do |t|
      t.string :map_name
      t.integer :num_of_squares

      t.timestamps
    end
  end
end
