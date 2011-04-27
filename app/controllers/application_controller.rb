class ApplicationController < ActionController::Base
  protect_from_forgery
  def index
    if admin_signed_in?
      redirect_to :users
    elsif user_signed_in?
      redirect_to :busses
    else
      redirect_to new_user_session_path
    end
    #render login page by default
  end
end
