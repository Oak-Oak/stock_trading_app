class ApplicationController < ActionController::Base
    protected

    def after_sign_in_path_for(resource)
        if resource.role == 'admin'
          admins_dashboard_path
        else
          traders_dashboard_path
        end
      end
end
