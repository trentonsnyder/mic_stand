class MessagesController < AuthorizedController
  def select
    event = current_user.events.find(params[:event_id])
    message = event.messages.find(params[:id])
    if message
      message.update(selected: Time.current)
    end
    head :ok
  end
end