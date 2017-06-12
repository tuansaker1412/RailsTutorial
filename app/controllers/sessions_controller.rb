class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user && user.authenticate(params[:session][:password])
      log_in user
      "1" == params[:session][:remember_me] ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = t ".error"
      render :new
    end
  end

  def destroy
    log_out
    flash[:success] = t ".logout"
    redirect_to root_url
  end
end
