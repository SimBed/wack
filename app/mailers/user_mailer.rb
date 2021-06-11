class UserMailer < ApplicationMailer
  def account_activation(user)
    @user = user
    mail to: user.email, subject: 'Wack - Account activation'
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'Wack - Password reset'
  end
end
