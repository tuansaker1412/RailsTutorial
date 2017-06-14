class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create]
  before_action :load_user, except: [:new, :create, :index]
  before_action :correct_user, only: [:edit, :update]
  before_action :verify_admin!, only: :destroy

  def index
    @users = User.order(:name).page(params[:page]).per_page Settings.page.limit_user
  end

  def new
   @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t ".check_mail"
      redirect_to root_url
    else
      flash.now[:danger] = t ".fail"
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".updated"
      redirect_to @user
    else
      flash.now[:danger] = t ".error"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".deleted"
      redirect_to users_url
    else
      flash[:danger] = t ".error"
      redirect_back fallback_location: users_url
    end
  end

  def verify_admin!
    redirect_to root_url unless current_user.admin?
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]

    check_url_user @user
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t ".please"
      redirect_to login_url
    end
  end

  def correct_user
    redirect_to root_url unless current_user.current_user? @user
  end
end
