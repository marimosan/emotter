class CreateEmos < ActiveRecord::Migration[5.0]
  def change
    create_table :emos do |t|
      t.text :content
      t.integer :tweet_id
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :emos, [:user_id, :created_at]
  end
end
