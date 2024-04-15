class RegistrationsController < Devise::RegistrationsController
  def create
    if params[:user][:isAdmin] == 'true'
      params[:user][:approved] = true
    else
      params[:user][:approved] = false
    end

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

    if current_user && current_user.isAdmin
      redirect_to admins_dashboard_path
    elsif current_user && !current_user.approved
      render 'traders/pending_approval'
    else
      render 'devise/registrations/new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :approved, :isAdmin)
  end  
end
  