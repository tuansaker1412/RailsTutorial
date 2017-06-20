class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def check_url_user object
    return if object
    render file: "public/404.html", layout: false
  end

  private

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t ".please"
      redirect_to login_url
    end
  end
end
