# frozen_string_literal: true

class CreateMatches < ActiveRecord::Migration[6.1]
  def change
    create_table :matches, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.date :started_at
      t.date :ended_at
      t.string :state
      
      t.references :match_type, null: false
      
      t.timestamps
    end
  end
end
