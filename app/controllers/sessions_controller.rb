class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      sign_in(user, params[:remember_me])
      flash[:success] = "Logged in!"
      redirect_to user
    else
      flash.now[:error] = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
