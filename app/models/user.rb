class User < ApplicationRecord
    has_many :emos
    has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
    has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
    has_many :following, through: :active_relationships, source: :followed
    has_many :followers, through: :passive_relationships, source: :follower
    def update_by_auth(auth)
      update(nickname: auth[:info][:nickname],
                  name: auth[:info][:name],
                  image_url: auth[:info][:image],
                  description: auth[:info][:description],
                  auth_token: auth[:credentials][:token],
                  auth_secret: auth[:credentials][:secret]
                  )
    end

    def update_following_auto
      twitter_client.friend_ids.each do |f_id|
        follow(User.find_by(uid: f_id)) if User.exists?(uid: f_id)
      end
      update(last_update_following: Time.now)
    end

    #フォローしているユーザーのエモ
    def following_emos
      following_ids = "SELECT followed_id FROM relationships
                       WHERE follower_id = :user_id"
      Emo.where("user_id IN (#{following_ids})
                       OR user_id = :user_id", user_id: id)
    end

    def followings_count
      Relationship.where(follower_id: self.id).count
    end

    def followers_count
      Relationship.where(followed_id: self.id).count
    end

    def self.find_or_create_from_auth(auth)
      provider = auth[:provider]
      uid = auth[:uid]
      user = self.find_or_create_by(provider: provider, uid: uid)
    end



    def twitter_client
      Twitter::REST::Client.new do |config|
        config.consumer_key = Rails.application.secrets.twitter_api_key
        config.consumer_secret = Rails.application.secrets.twitter_api_secret
        config.access_token = self.auth_token
        config.access_token_secret = self.auth_secret
      end
    end



    def follow_if_not(other_user)
      follow(other_user) unless following?(other_user)
    end

    # ユーザーをフォローする
    def follow(other_user)
      active_relationships.create(followed_id: other_user.id) unless following?(other_user)
    end

    # ユーザーをフォロー解除する
    def unfollow(other_user)
      active_relationships.find_by(followed_id: other_user.id).destroy if following?(other_user)
    end

    # 現在のユーザーがフォローしてたらtrueを返す
    def following?(other_user)
      following.include?(other_user)
    end


    def create_emo(emo_attr)
      #過去10回のエモに基づいて文言生成
      text = make_emo_text(emo_attr)
      #エモをツイートする
      twitter_client.update!(text)
      #今のツイートのIDを取得する
      tweet_id = twitter_client.user_timeline.first.id
      #今のツイートをエモモデルに追加する
      emos.create(content: text, content_attr: emo_attr, tweet_id: tweet_id, user_id: id)
    end

    def emo_count(emo_attr)
      emos.where(content_attr: emo_attr).count
    end

    def destroy(tweet_delete_option: true)
      emos.each do |emo|
        emo.destroy(tweet_delete_option: tweet_delete_option)
      end
      super()
    end

    private
      def make_emo_text(emo_attr)
        basic_text = emo_text(emo_attr)
        #過去10回に同属性のエモが無ければ基本形のままreturn
        return basic_text unless in_last_10_emo_attr?(emo_attr)
        #60秒以内の同属性のエモの数
        same_count_60sec = in_last_60_sec(emo_attr)

        text = tweak_emo_text(text: basic_text, level: same_count_60sec)
      end

      def in_last_10_emo_attr?(emo_attr)
        emos.limit(10).map{|a| a.content_attr == emo_attr}.include?(true)
      end

      def in_last_60_sec(emo_attr)
        count = 0
        emos.limit(10).each do |emo|
          if Time.now - emo.created_at < 60
            count += 1 if emo_attr == emo.content_attr
          else
            return count
          end
        end
        count
      end

      def tweak_emo_text(text: "喜んでる", level: 0)
        old_emos = emos.limit(10).collect{|a| a.content}
        if level == 0
          10.times do
            if old_emos.include?(text)
              text = "また#{text}"
            else
              return text
            end
          end
        else
          text = "超#{text}"
          level.times do
            if old_emos.include?(text)
              text = "超#{text}"
            else
              return text
            end
          end
          if old_emos.include?(text)
            text = "また#{text}"
          end
        end
        text
      end

      def emo_text(emo_attr)
        unless Rails.env == "production"
          case emo_attr
          when "joy"
            return "テストj"
          when "anger"
            return "テストa"
          when "sad"
            return "テストs"
          when "happiness"
            return "テストh"
          end
        else
          case emo_attr
          when "joy"
            return "喜んでる"
          when "anger"
            return "怒ってる"
          when "sad"
            return "悲しんでる"
          when "happiness"
            return "楽しんでる"
          end
        end
      end

end
