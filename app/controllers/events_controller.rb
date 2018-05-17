class EventsController < AuthorizedController
  def index
    @events = current_user.events
                          .includes(:phone_number)
                          .order("session_expiry desc")
  end

  def show
    @event = current_user.events.find(params[:id])
    @messages = @event.messages
  end
end