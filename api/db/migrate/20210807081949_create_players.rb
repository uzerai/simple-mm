# frozen_string_literal: true

class CreatePlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :players, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :username, null: false
      t.integer :rating

      t.references :user, type: :uuid, null: true
      t.references :game, type: :uuid, null: false
      t.references :league, type: :uuid, null: false

      t.timestamps
    end
  end
end
