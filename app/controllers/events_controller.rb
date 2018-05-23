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
    if current_user.available_credits.count.positive?
      @event = current_user.events.new
    else
      redirect_to new_purchase_path
    end
  end

  def create
    @event = current_user.events.new(event_params)
    if @event.register
      redirect_to events_path
    else
      render :new
    end
  end

  private

  def event_params
    params.require(:event).permit(:name, :duration)
  end
end