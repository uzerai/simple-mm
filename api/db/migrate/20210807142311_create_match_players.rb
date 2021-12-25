# frozen_string_literal: true

class CreateMatchPlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :match_players, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.integer :start_rating
      t.integer :end_rating

      t.references :match_team, type: :uuid
      t.references :player, type: :uuid
      
      t.timestamps
    end
  end
end
