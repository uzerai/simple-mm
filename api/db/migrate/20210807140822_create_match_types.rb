class CreateMatchTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :match_types, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :name, null: false
      t.integer :team_size, null: false
      t.integer :team_count, null: false
      
      t.references :game, null: false

      t.timestamps
    end
  end
end
