class ApplicationController < ActionController::Base
  protected

  def after_sign_in_path_for(resource)
    if resource.isAdmin && resource.confirmed?
      return admins_dashboard_path
    elsif !resource.isAdmin && resource.confirmed?
      if !resource.approved
        UserMailer.account_pending_admin(resource).deliver_now
      end
      return traders_dashboard_path
    else
      flash[:unconfirmed] = "Please confirm your email address to log in."
      return new_user_session_path
    end
  end
end
