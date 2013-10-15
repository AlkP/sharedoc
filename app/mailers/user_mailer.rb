class UserMailer < ActionMailer::Base

  default from: "from@example.com"

  def welcome_email(user, url)

    @user_v = user
    @url = url

    mail(to: user.email,
         subject: 'Welcome to Site Pen Test ')
  end

  def shared_email(user, shared, url)

    @user_v = user
    @user_shared = shared
    @url = url

    @subject = shared.email + " shared document with you."

    mail(to: user,
         subject: @subject)
  end

  def invite_email(user, shared, url)

    @user_v = user
    @user_shared = shared
    @url = url

    @subject = shared.email + " invite you in ours site."

    mail(to: user,
         subject: @subject)
  end

end
