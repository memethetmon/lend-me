class SessionsController < ApplicationController

	def create
		user = Lender.find_by(email: params[:email])
		if user
			if user.authenticate(params[:password])
				session[:user_id] = user.id
				session[:user_type] = "lender"
				redirect_to "/online_lending/lender/#{user.id}"
			else
				flash[:errors] = ["Invalid Combination"]
				redirect_to :back
			end
		else
			user = Borrower.find_by(email: params[:email])
			if user && user.authenticate(params[:password])
				session[:user_id] = user.id
				session[:user_type] = "borrower"
				redirect_to "/online_lending/borrower/#{user.id}"
			else
				flash[:errors] = ["Invalid Combination"]
				redirect_to :back
			end
		end
	end

	def destroy
		session[:user_id] = nil
		session[:user_type] = nil
		redirect_to '/online_lending/login'
	end
end