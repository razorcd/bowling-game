class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :score, default: 0, null: false
      t.string :frames, default: nil, limit: 1024

      t.timestamps null: false
    end
  end
end
