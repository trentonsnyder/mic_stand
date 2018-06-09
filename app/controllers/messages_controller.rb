class MessagesController < AuthorizedController
  def select
    @event = current_user.events.find(params[:event_id])
    @message = @event.messages.find(params[:id])
    if @message
      @message.update(selected: Time.current)
      ActionCable.server.broadcast "broadcast_channel_#{@event.broadcast_token}",
        body:  @message.body
    end
    respond_to do |format|
      format.js {}
    end
  end
end