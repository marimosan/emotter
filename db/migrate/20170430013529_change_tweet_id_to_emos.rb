class ChangeTweetIdToEmos < ActiveRecord::Migration[5.0]
  def change
    change_column :emos, :tweet_id, :bigint
  end
end
