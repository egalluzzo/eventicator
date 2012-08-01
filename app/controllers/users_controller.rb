class UsersController < ApplicationController
  before_filter :not_signed_in,  only: [:new, :create]
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: [:destroy]

  def index
    @users = User.page(params[:page]).order('name ASC')
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Thanks for signing up!"
      sign_in @user, false
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    # @user is set by the before_filter (correct_user)
  end

  def update
    # @user is set by the before_filter (correct_user)
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user, false
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    if (user == current_user)
      redirect_to root_path, error: "Cannot delete the logged-in user."
    else
      user.destroy
      redirect_to users_path, success: "User deleted."
    end
  end
end
