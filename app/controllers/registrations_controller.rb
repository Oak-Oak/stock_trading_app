class RegistrationsController < Devise::RegistrationsController
  def create
    @user = User.new(user_params)

    if @user.save && @user.confirmed?
      redirect_to traders_dashboard_path
    else
      flash[:alert] = "Please confirm your email address to sign up."
      redirect_to new_user_registration_path
    end
  end

  def new
    @user = User.new
    render 'devise/registrations/new'
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :approved, :isAdmin)
  end  
end
  