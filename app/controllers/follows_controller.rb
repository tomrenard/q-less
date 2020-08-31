class FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user

  def create
    @follow = Follow.new
    current_user.follow(@user)
    authorize @follow
    redirect_back fallback_location: root_path
  end

  def destroy
    @follow = current_user.find_follow(@user)
    authorize @follow
    current_user.unfollow(@user)
    redirect_back fallback_location: root_path
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end
end
