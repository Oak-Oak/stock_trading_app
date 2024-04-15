class Admins::DashboardController < ApplicationController
    def index
        @traders = User.where(isAdmin: false, approved: true).order(created_at: :asc)
        @pending_traders = User.where(isAdmin: false, approved: false).order(created_at: :asc)
      end

      def approve_trader
        trader = User.find(params[:id])
        trader.update(approved: true)
        redirect_to admins_dashboard_path, notice: "#{trader.email} has been approved as a trader."
      end
    
      def reject_trader
        trader = User.find(params[:id])
        trader.destroy
        redirect_to admins_dashboard_path, notice: "#{trader.email} has been rejected and removed."
      end


end
