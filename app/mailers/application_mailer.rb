class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def welcome_email(user)
    @user = user
    @url  = 'localhost:3000/session/new'
    mail(to: user.email, subject: 'Welcome to Music App')
  end

end
