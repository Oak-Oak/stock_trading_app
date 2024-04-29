class Traders::DashboardController < ApplicationController
  before_action :authenticate_trader
  before_action :initialize_iex

    def index
      @transactions = current_user.transactions.group_by(&:symbol)
      @total_quantity_per_stock = calculate_total_quantity_per_stock(@transactions)

      fetch_stock_quote if params[:symbol].present?
    end
  
    private

   

    def authenticate_trader
      if current_user.nil? 
        flash[:alert] = "You are not authorized to access this page."
        redirect_to root_path
      elsif current_user.isAdmin
        redirect_to admins_dashboard_path
      end
    end
    
  
    def calculate_total_quantity_per_stock(transactions)
      total_quantity_per_stock = {}
  
      transactions.each do |symbol, symbol_transactions|
        total_quantity_per_stock[symbol] = symbol_transactions.sum(&:quantity)
      end
  
      total_quantity_per_stock
    end

    def initialize_iex
      @client = IEX::Api::Client.new
    end
    
    def fetch_stock_quote
      @client = IEX::Api::Client.new
      @symbol = params[:symbol]
      @stock_quote = @client.quote(@symbol)
    end
  end
  

