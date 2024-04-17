class Admins::TradersController < ApplicationController
  before_action :set_trader, only: [:show, :edit, :update, :destroy]

    def show
    end
  
    def edit
    end
  
    def update
      if @trader.update(user_params)
        redirect_to admins_trader_path(@trader), notice: "Trader updated successfully."
      else
        render :edit
      end
    end

    def create
        @user = User.new(user_params)
        if @user.save
          redirect_to admins_dashboard_path, notice: "Trader created successfully."
        else
          flash[:alert] = @user.errors.full_messages.join(", ")
          redirect_to admins_dashboard_path
        end
      end

    def destroy
      @trader.destroy
      redirect_to admins_dashboard_path, notice: "Trader deleted successfully."
    end
  
    private
  
    def set_trader
      @trader = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :password, :approved, :isAdmin)
    end
end
