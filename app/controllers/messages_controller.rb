class MessagesController < AuthorizedController
  def select
    @event = current_user.events.find_by!(id: params[:event_id])
    @message = @event.messages.find_by!(id: params[:id])
    if @message
      @message.update_columns(selected: Time.current) if @message.selected.nil?
      ActionCable.server.broadcast "broadcast_channel_#{@event.broadcast_token}",
        body:  @message.body
    end
    respond_to do |format|
      format.js {}
    end
  end
end