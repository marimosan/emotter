module UsersHelper
  def twitter_link(user)
    link_to " (twitter)","https://twitter.com/#{user.nickname}", :target=>["_blank"]
  end

  def following_check(user)
    if logged_in?
      if current_user.following?(user)
        "フォロー中"
      else
        "未フォロー"
      end
    end
  end

  def newest_emo(user)
    if Emo.exists?(user_id: user.id)
      "最後のエモ #{Emo.find_by(user_id: user.id).content}"
    else
      "未エモ"
    end
  end
end
