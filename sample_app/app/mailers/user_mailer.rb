class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end

  def follow_notification(user, other_user)
  	@user = user
    @other_user = other_user
  	mail to: other_user.email, subject: "You get new Follower"
  end
end
