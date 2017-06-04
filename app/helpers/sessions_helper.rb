module SessionsHelper
  def current_user
    if (user_id = session[:user_id])
      @current_user || User.find_by(id: user_id)
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def set_emo(emo)
    session[:emo] = emo
  end

  def emo_text(emo)
    unless Rails.env == "production"
      case emo
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
      case emo
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
