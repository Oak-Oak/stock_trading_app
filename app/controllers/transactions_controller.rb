class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @transactions = current_user.transactions
  end

  def new
    @transaction = current_user.transactions.build
  end

  def create
    @transaction = current_user.transactions.build(transaction_params)
    if @transaction.save
      redirect_to transactions_path, notice: "Transaction successful."
    else
      render :new
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:action, :symbol, :quantity, :price)
  end
  
end
