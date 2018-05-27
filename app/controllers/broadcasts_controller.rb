class BroadcastsController < ApplicationController
  def show
    @event = Event.find_by(broadcast_token: params[:token])
    if @event
      render :show
    else
      # render 404
    end
  end
end