class BroadcastsController < ApplicationController
  def show
    @event = Event.find_by(broadcast_token: params[:token])
    if @event
      render :show
    else
      # render 404
    end
  end

  def mailer
    BroadcastMailer.with(broadcast: params[:broadcast], email: params[:email]).link_email.deliver_later
  end
end
