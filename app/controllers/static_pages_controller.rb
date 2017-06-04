class StaticPagesController < ApplicationController
  before_action :set_emo, :update_following, only: [:home, :about]

  def home
  end

  def about
  end

  def global
    set_emo(global_force: true)
  end

  def setting
  end

  private
    def set_emo(global_force: false)
      if logged_in? && !global_force
        @user ||= User.find(session[:user_id])
        @emos = @user.following_emos.paginate(page: params[:page])
        @timeline_mode = "my"
      else
        @emos = Emo.paginate(page: params[:page])
        @timeline_mode = "global"
      end
    end

    def update_following
      if logged_in?
        @user ||= User.find(session[:user_id])
        #最終更新から5分以上経過している場合のみ更新する
        if Time.now - @user.last_update_following > 5 * 60
          @user.update_following_auto
        end
      end
    end
end
