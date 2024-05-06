class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :initialize_iex

  def index
    @transactions = current_user.transactions
    fetch_stock_quote_and_chart if params[:symbol].present?
  end

  def create
    @symbol = params[:symbol]
    @quantity = params[:quantity].to_i
    fetch_stock_quote
  
    return if @stock_quote.nil?
  
    transaction_cost = @stock_quote.latest_price.to_i * @quantity
    ensure_sufficient_funds(transaction_cost)
  
    update_user_account_value(transaction_cost)
    create_transaction("buy")
  rescue IEX::Errors::SymbolNotFoundError
    flash.now[:notice] = "Stock not found."
    render :index
  rescue => e
    flash[:error] = "Transaction failed: #{e.message}"
    render :index
  end
  
  def sell
    @symbol = params[:symbol]
    @quantity = params[:quantity].to_i
    fetch_stock_quote
  
    return if @stock_quote.nil?
  
    transaction_cost = @stock_quote.latest_price.to_i * @quantity
    ensure_sufficient_stocks(@symbol, @quantity)
  
    update_user_account_value(-transaction_cost)
    create_transaction("sell")

  rescue IEX::Errors::SymbolNotFoundError
    flash.now[:notice] = "Stock not found."
    render :index
  rescue => e
    flash[:error] = "Transaction failed: #{e.message}"
    render :index
  end


  private

  def initialize_iex
    @client = IEX::Api::Client.new
  end

  def fetch_stock_quote_and_chart
    fetch_stock_quote
    @line_chart_data = fetch_stock_chart_data(@symbol)
  end

  def fetch_stock_quote
    @client = IEX::Api::Client.new
    @symbol = params[:symbol]
    @stock_quote = @client.quote(@symbol)
    @chart_data = fetch_stock_chart_data(@symbol)
  end

  def fetch_stock_chart_data(symbol)
    historical_data = @client.chart(symbol, '5y')
    chart_data = {}
  
    historical_data.each do |data|
      chart_data[data.date.strftime("%Y-%m-%d")] = data.close
    end
  
    chart_data
  end
  

  def ensure_sufficient_funds(transaction_cost)
    raise "Insufficient funds." if current_user.account_value < transaction_cost
  end

  def update_user_account_value(amount)

    puts "update user acc value"
    puts current_user.account_value
    puts amount
    current_user.update!(account_value: current_user.account_value - amount)

  end

  def create_transaction(transaction_type)

    puts "create transaction #{current_user.transactions.inspect}"

    @transaction = current_user.transactions.create!(
      symbol: @symbol,
      quantity: @quantity,
      price: @stock_quote.latest_price,
      action: transaction_type
    )
    flash[:success] = "Transaction successful."

    puts @transaction
    redirect_to action: :index, symbol: @symbol
  end

  def ensure_sufficient_stocks(symbol, quantity)
    total_quantity = current_user.transactions.where(symbol: symbol, action: 'buy').sum(:quantity)
    raise "Insufficient quantity of stocks." if total_quantity < quantity
  end
  

end
