class UsersController < ApplicationController
  before_action :load_user, only: :show

  def new
   @user = User.new
  end

  def show;
  end

  def create
    @user = User.new user_params

    if @user.save
      flash[:success] = t ".welcome"
      redirect_to @user
    else
      flash.now[:danger] = t ".fail"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]

    return if @user
      render file: "public/404.html", layout: false
  end
end
