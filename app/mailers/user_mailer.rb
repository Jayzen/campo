class UserMailer < ApplicationMailer
  default from: "zhengjiajun121@gmail.com"

  def password_reset
    @user = params[:user]
    mail(subject: 'Reset password', to: @user.email)
  end

  def welcome_email
    mail(to: "645112281@qq.com", subject: "Welcome to My Awesome Site")
  end
end
