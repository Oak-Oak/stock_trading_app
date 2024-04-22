class Traders::DashboardController < ApplicationController
    def index
      @transactions = current_user.transactions.group_by(&:symbol)
      @total_quantity_per_stock = calculate_total_quantity_per_stock(@transactions)
    end
  
    private
  
    def calculate_total_quantity_per_stock(transactions)
      total_quantity_per_stock = {}
  
      transactions.each do |symbol, symbol_transactions|
        total_quantity_per_stock[symbol] = symbol_transactions.sum(&:quantity)
      end
  
      total_quantity_per_stock
    end
  end
  