class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :name
      t.string :image_url

      t.timestamps
    end
  end
end
