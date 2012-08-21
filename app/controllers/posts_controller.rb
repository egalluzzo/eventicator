class PostsController < ApplicationController
  before_filter :signed_in_user,        only: [:new, :create, :edit, :update, :destroy]
  before_filter :correct_user_or_admin, only: [:edit, :update, :destroy]

  def index
    @posts = Post.page(params[:page])
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(params[:post])
    if @post.save
      flash[:success] = "Created post #{@post.title}."
      redirect_to @post
    else
      render 'new'
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      flash[:success] = "Post updated."
      redirect_to @post
    else
      render 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to root_path, success: "Removed post #{post.title}."
  end

  private
    def correct_user_or_admin
      @post = Post.find(params[:id])
      unless @post && (current_user.admin? || @post.user == current_user)
        redirect_to root_path
      end
    end
end
