class UsersController < ApplicationController
  before_action :logged_in_check, only: [:destroy, :index_following, :index_follower]
  def show
    @user = User.find_by(nickname: params[:nickname])
    @emos = @user.emos.paginate(page: params[:page])
    @timeline_mode = "other"
  end

  def destroy
    option = params[:tweet_delete_option] || false
    User.find(session[:user_id]).destroy(tweet_delete_option: option)
    flash[:success] = "ユーザー情報を削除しました"
    redirect_to root_path
  end

  def index
    @users_mode = "all"
    @users = User.paginate(page: params[:page])
  end

  def index_following
    @users_mode = "following"
    @users = User.find(session[:user_id]).following.paginate(page: params[:page])
    render "index"
  end

  def index_follower
    @users_mode = "follower"
    @users = User.find(session[:user_id]).followers.paginate(page: params[:page])
    render "index"
  end

  private
    def destroy_params
      params.require(:tweet_delete_option)
    end
    def logged_in_check
      redirect_to root_url unless logged_in?
    end
end
