class RegistrationsController < Devise::RegistrationsController
    def create
      if params[:user][:isAdmin] == 'true'
        params[:user][:approved] = true
      else
        params[:user][:approved] = false
      end
  
      super
    end
  
    def new
        @user = User.new
    
        if current_user && current_user.isAdmin
          redirect_to admins_dashboard_path
        elsif current_user && !current_user.approved
          render 'traders/pending_approval'
        else
          render 'devise/registrations/new'
        end
      end
      
      
  end
  