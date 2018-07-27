class BroadcastMailer < ActionMailer::Base
  # TODO: change this from example.com
  default from: 'no-reply@example.com'
 
  def link_email
    broadcast = params[:broadcast]
    email  = params[:email]
    @link   = "#{ENV['BASE_URL']}/broadcasts/#{broadcast}"
    mail(to: email, subject: 'Broadcast link from Mic Stand')
  end
end
