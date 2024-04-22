class Admins::DashboardController < ApplicationController
  before_action :authenticate_admin

  def index
    @traders = User.where(isAdmin: false, approved: true).order(created_at: :asc)
    @pending_traders = User.where(isAdmin: false, approved: false).order(created_at: :asc)
    @transactions = Transaction.all
  end

  def approve_trader
    trader = User.find(params[:id])
    UserMailer.account_approved(trader).deliver_now
    trader.update(approved: true)
    redirect_to admins_dashboard_path, notice: "#{trader.email} has been approved as a trader."
  end
    
  def reject_trader
    trader = User.find(params[:id])
    UserMailer.account_rejected(trader).deliver_now
    trader.destroy
    redirect_to admins_dashboard_path, notice: "#{trader.email} has been rejected and removed."
  end

  private

  def authenticate_admin
    unless current_user && current_user.isAdmin
      flash[:alert] = "You are not authorized to access this page."
      redirect_to root_path
    end
  end

end
