# frozen_string_literal: true

class CreateMatchTeams < ActiveRecord::Migration[6.1]
  def change
    create_table :match_teams do |t|
      t.string :outcome, null: true
      t.integer :avg_rating, null: false

      t.references :match

      t.timestamps
    end
  end
end
