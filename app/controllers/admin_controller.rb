# Administrator controller
class AdminController < ApplicationController
  before_filter :authenticate_user!

  def index
    @posts = Post.recent.page(params[:page]).per(10)
  end
end
