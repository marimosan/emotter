class Emo < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true

  def self.statistic_emo_hash(emo_attr)
    where(content_attr: emo_attr).count
  end

  def destroy(tweet_delete_option: true)
    begin
      user.twitter_client.destroy_status(tweet_id) if tweet_delete_option
    rescue Twitter::Error
    end
    super()
  end
end
