class UserMailer < ApplicationMailer
    def account_confirmation(user)
        @user = user
        mail(to: @user.email, subject: "Account Confirmation")
      end
      
      def account_pending_admin(user)
        @user = user
        mail(to: 'admin@example.com', subject: "New Account Pending Approval")
      end
end
