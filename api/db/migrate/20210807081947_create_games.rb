# frozen_string_literal: true

class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :cover_image, null: true

      # Physical games come way later, but we'll need
      # an indicator anyhow; might as well be on the game.
      t.boolean :physical, default: false

      t.timestamps
    end

    create_table :games_tags, id: false do |t|
      t.belongs_to :game
      t.belongs_to :tag
    end

    add_index :games, :slug, unique: true
  end
end
