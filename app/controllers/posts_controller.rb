# -*- coding: utf-8 -*-

class PostsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show, :monthly_archive]

  def index
    @posts = Post.recent.page(params[:page]).per(5)
    respond_to do |format|
      format.html { set_cache_control_header }
      format.rss { render(:layout => false) }  # index.rss.builder
    end
  end

  def show
    set_cache_control_header
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
      flash[:notice] = 'Post was successfully created.' unless Settings.caching['use']
      redirect_to @post
    else
      render :action => 'new'
    end
  end

  def update
    @post = Post.find(params[:id])

    if @post.update_attributes(params[:post])
      flash[:notice] = 'Post was successfully updated.' unless Settings.caching['use']
      redirect_to @post
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
    @posts = Post.created_within(t.beginning_of_month, t.end_of_month).oldest.page(params[:page]).per(100)
    set_cache_control_header
    render :index
  end


  protected

  def set_cache_control_header
    response.headers['Cache-Control'] = 'public, max-age=300' if Settings.caching['use']
  end
end
