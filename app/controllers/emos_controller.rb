class EmosController < ApplicationController
  before_action :logged_in_check, only: [:destroy, :create]
  def index
  end

  def destroy
    Emo.find(params[:id]).destroy
    flash[:success] = "エモを削除しました"
    redirect_to :back
  end

  def create
    user = User.find(session[:user_id])
    begin
      user.create_emo(session[:emo])
    rescue Twitter::Error::DuplicateStatus
      flash[:danger] = "エモに失敗しました。時間を空けて試してください！"
    else
      flash[:success] = "エモりました"
    end
    redirect_to root_path
  end

  def change_emo
    session[:emo] = params[:emo]
    render nothing: true
  end

  def change_tab
    case params[:mode]
    when "global"
      @emos = Emo.all
    when "my"
      @user = User.find(session[:user_id])
      @emos = @user.following_emos
    when "other"
      @user = User.find_by(nickname: params[:user])
      @emos = @user.emos
    else
      @user = User.find(session[:user_id])
      @emos = @user.following_emos.paginate(page: params[:page])
    end
    if params[:emo] == "all"
      @emos = @emos.paginate(page: params[:page])
    else
      emo = view_context.emo_text(params[:emo])
      @emos = @emos.where(content: emo).paginate(page: params[:page])
    end
    html = render_to_string :partial => "emos/emo_timeline"
    render :json => {:success => 1, :html => html}
  end

  private
    def logged_in_check
      redirect_to root_url unless logged_in?
    end
end
