class CreateMatchTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :match_types do |t|
      t.string :name, null: false
      t.integer :team_size, null: false
      t.integer :team_count, null: false

      t.timestamps
    end
  end
end
