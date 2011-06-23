class ApplicationController < ActionController::Base
  protect_from_forgery
  def index
    if admin_signed_in?
      redirect_to :users, :flash=>flash
    elsif user_signed_in?
      redirect_to :busses, :flash=>flash
    else
      redirect_to "/welcome", :flash=>flash
    end
    #render login page by default
  end
end
