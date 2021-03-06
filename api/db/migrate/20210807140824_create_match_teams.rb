# frozen_string_literal: true

class CreateMatchTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :match_teams, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.integer :outcome, null: true
      t.integer :avg_rating, null: false

      t.references :match, type: :uuid

      t.timestamps
    end
  end
end
