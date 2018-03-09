class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def welcome_email(user)
    @user = user
    @url  = 'http://www.localhost:3000/session/new'
    mail(to: user.email, subject: 'Welcome to the Music App')
  end
end
