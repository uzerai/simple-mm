# frozen_string_literal: true

class CreateMatchPlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :match_players do |t|
      t.references :player
      t.references :match_team

      t.integer :start_rating
      t.integer :end_rating
      t.timestamps
    end
  end
end
