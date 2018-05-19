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

  def new
    # if current_user.credits.count.positive?
      @event = current_user.events.new
    # else
    #   redirect_to new_credit_path
    # end
  end
end