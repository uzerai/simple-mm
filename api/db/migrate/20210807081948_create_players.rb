# frozen_string_literal: true

class CreatePlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :players do |t|
      t.string :username
      t.integer :rating
    
      t.references :user, null: false
      t.references :game, null: false

      t.timestamps
    end
  end
end
