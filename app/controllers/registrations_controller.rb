class RegistrationsController < Devise::RegistrationsController
  def create
    @user = User.new(user_params)

    if @user.save
      UserMailer.account_confirmation(@user).deliver_now
      UserMailer.account_pending_admin(@user).deliver_now
      redirect_to traders_dashboard_path
    else
      render :new
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
  