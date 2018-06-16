class BroadcastMailer < ActionMailer::Base
  default from: 'no-reply@example.com'
 
  def link_email
    broadcast = params[:broadcast]
    email  = params[:email]
    @link   = "http://www.google.com/#{broadcast}"
    mail(to: email, subject: 'Broadcast from llamas')
  end
end