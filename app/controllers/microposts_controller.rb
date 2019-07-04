class MicropostsController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]
  def create
    #@micropost = Micropost.new(micropost_params) user_idがセットされない
    @micropost = current_user.microposts.build(micropost_params)
    if (@micropost.save)
      flash[:success] = "投稿成功"
      redirect_to root_url
    else
      flash.now[:danger] = "投稿失敗"
      @microposts = current_user.feed_microposts.order(id: :desc).page(params[:page])
      render 'toppages/index'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = '投稿削除'
    redirect_back(fallback_location: root_path)
    
  end
  
  private
  def micropost_params
    params.require(:micropost).permit(:content)
  end
  
  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    unless @micropost
    redirect_to root_url
    end
  end
end
