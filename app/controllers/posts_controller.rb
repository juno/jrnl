# -*- coding: utf-8 -*-

class PostsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show, :monthly_archive]

  def index
    @posts = Post.recent.paginate(:page => params[:page], :per_page => 5)
    respond_to do |format|
      format.html { response.headers['Cache-Control'] = 'public, max-age=300' }
      format.rss { render(:layout => false) }  # index.rss.builder
    end
  end

  def show
    response.headers['Cache-Control'] = 'public, max-age=300'
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(params[:post])

    if @post.save
      redirect_to(new_post_url, :notice => 'Post was successfully created.')
    else
      render :action => 'new'
    end
  end

  def update
    @post = Post.find(params[:id])

    if @post.update_attributes(params[:post])
      redirect_to(edit_post_url(@post), :notice => 'Post was successfully updated.')
    else
      render :action => 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to(posts_url)
  end

  def monthly_archive
    t = Time.new(params[:year], params[:month], 1)
    @posts = Post.created_within(t.beginning_of_month, t.end_of_month).oldest.paginate(:page => params[:page], :per_page => 100)
    response.headers['Cache-Control'] = 'public, max-age=300'
    render :index
  end
end
