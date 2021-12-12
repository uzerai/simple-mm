# frozen_string_literal: true

class CreateMatches < ActiveRecord::Migration[6.1]
  def change
    create_table :matches do |t|
      t.references :match_type, null: false

      t.date :started_at
      t.date :ended_at
      t.string :state
      
      t.timestamps
    end
  end
end
