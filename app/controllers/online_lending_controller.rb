class OnlineLendingController < ApplicationController
	before_action :require_login, except: [:register, :login, :create_lender, :create_borrower, :destroy]
	# before_action :require_correct_user, only: [:show_lender, :show_borrower]

  def register
  	# render '/online_lending/register'
  end

  def login
  	# render '/online_lending/login'
  end

  def create_lender
  	lender = Lender.new(lender_params)
  	if lender.save
  		session[:user_id] = lender.id
  		redirect_to "/online_lending/lender/#{lender.id}"
  	else
  		flash[:errors] = lender.errors.full_messages
  		redirect_to :back
  	end
  end

  def create_borrower
  	borrower = Borrower.new(borrower_params)
  	if borrower.save
  		session[:user_id] = borrower.id
  		redirect_to "/online_lending/borrower/#{borrower.id}"
  	else
  		flash[:errors] = borrower.errors.full_messages
  		redirect_to :back
  	end
  end

  def show_lender
  	if session[:user_type] == 'lender'
	  	@lender = Lender.find(params[:id])
	  	@borrowers = Borrower.all
	  	@history = History.create(amount: params[:amount].to_i, lender: Lender.find(session[:user_id]), borrower: params['borrower_id'])
	  	@lendees = History.joins(:borrower).select("*").where(lender:Lender.find(params[:id]))

	else
		redirect_to :back
	end
  end

  def show_borrower
  	@borrower = Borrower.find(params[:id])
  	@lenders = History.joins(:lender).select('*').where(borrower:Borrower.find(params[:id]))
  end

  def money_lent
  	@lender = Lender.find(session[:user_id])
  	@updated_money = @lender.money - params[:amount].to_i
  	@lender.update(money: @updated_money)
  	@borrower = Borrower.find(params[:borrower_id])
  	if @borrower.raised == nil
  		@borrower.update(raised: 0.to_i)
  	else
  		@borrower.update(raised: @borrower.raised + params[:amount].to_i)
  	end
	@history = History.create(amount: params[:amount].to_i, lender: @lender, borrower: @borrower)

  	redirect_to :back
  end

#   	
#   	json_message = {first_name:@borrower.first_name, last_name:@borrower.last_name, purpose:@borrower.purpose, description:@borrower.description, money:@borrower.money, raised:@borrower.raised, amount:@history.amount}
#   	render json: json_message

  private
  	def lender_params
  		params.require(:lender).permit(:first_name, :last_name, :email, :password, :money)
  	end

  	def borrower_params
  		params.require(:borrower).permit(:first_name, :last_name, :email, :password, :money, :purpose, :description, :raised)
  	end
end
