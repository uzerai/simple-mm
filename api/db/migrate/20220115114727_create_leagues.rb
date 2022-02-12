# frozen_string_literal: true

class CreateLeagues < ActiveRecord::Migration[7.0]
  def change
    create_table :leagues do |t|
      t.string :name, null: false
      t.string :slug,  null: false

      t.boolean :rated, default: true
      t.boolean :public, default: false
      t.boolean :official, default: false

      t.references :game, null: false
      t.references :match_type, type: :uuid, null: :true

      t.timestamps
    end

    add_index :leagues, [:slug, :game_id], unique: true

    create_table :leagues_tags do |t|
      t.belongs_to :league
      t.belongs_to :tag
    end
  end
end
