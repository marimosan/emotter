class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :nickname
      t.string :name
      t.string :image_url
      t.string :description
      t.string :auth_token
      t.string :auth_secret

      t.timestamps
    end
  end
end
