# frozen_string_literal: true

class CreateLeagues < ActiveRecord::Migration[7.0]
  def change
    create_table :leagues, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :name, null: false
      t.text :desc, null: true
      t.string :cover_image, null: true

      t.boolean :rated, default: true
      t.boolean :public, default: false
      t.boolean :official, default: false

      t.references :game, type: :uuid, null: false
      t.references :match_type, type: :uuid, null: true

      t.timestamps
    end

    create_table :leagues_tags do |t|
      t.belongs_to :league
      t.belongs_to :tag
    end
  end
end
