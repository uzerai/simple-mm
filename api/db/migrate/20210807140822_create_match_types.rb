# frozen_string_literal: true

class CreateMatchTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :match_types, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :name, null: false
      t.string :slug, null: false

      t.integer :team_size, null: false
      t.integer :team_count, null: false
      
      t.references :game, null: false

      t.timestamps
    end
  end
end
