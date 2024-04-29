class UserMailer < ApplicationMailer
    def account_pending_admin(user)
        @user = user
        mail(to: 'misterrailstesterman@gmail.com', subject: "New Account Pending Approval")
    end

    def account_approved(user)
        @user = user
        mail(to: @user.email, subject: "Your account has been approved")
    end

    def account_rejected(user)
        @user = user
        mail(to: @user.email, subject: "Your account has been rejected")
    end
end
