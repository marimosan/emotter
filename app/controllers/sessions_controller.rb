class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    user = User.find_or_create_from_auth(auth)
    user.update_by_auth(auth)
    session[:user_id] = user.id
    user.update_following_auto
    flash[:success] = "えもったーにログインしました！"
    redirect_to root_path
  end

  def destroy
    reset_session
    flash[:success] = "ログアウトしました"
    redirect_to root_path
  end
end
