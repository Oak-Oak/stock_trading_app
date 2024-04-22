class Traders::DashboardController < ApplicationController
  before_action :authenticate_trader

    def index
      @transactions = current_user.transactions.group_by(&:symbol)
      @total_quantity_per_stock = calculate_total_quantity_per_stock(@transactions)
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
  end
  