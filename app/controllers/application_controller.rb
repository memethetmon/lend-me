class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # def current_user
  #   if session[:user_id]
  #     Lender.find(session[:user_id]) or Borrower.find(session[:user_id])
  #   end
  # end

  def require_login
  	redirect_to '/online_lending/login' if session[:user_id] == nil
  end

  # def require_correct_user
  #   lender = Lender.find(params[:id])
  #   if current_user != 'lender'
  #     redirect_to "/online_lending/borrower/#{current_user.id}"
  #   else
  #     redirect_to "/online_lending/lender/#{current_user.id}"
  #   end
  # end

  # helper_method :current_user
end