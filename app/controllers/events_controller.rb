class EventsController < AuthorizedController

  def index
    @events = current_user.events
                          .current
                          .includes(:phone_number)
                          .order("session_expiry desc")
  end

  def expired
    @events = current_user.events
                          .expired
                          .includes(:phone_number)
                          .order("created_at desc")
  end

  def show
    @event = current_user.events.find(params[:id])
    @filters = request.query_parameters
    @messages = @event.messages
                      .filter(@filters.slice(:search, :ordering))
                      .page(params[:page])
  end

  def new
    if current_user.available_credits.count.positive?
      @event = current_user.events.new
    else
      redirect_to new_purchase_path
    end
  end

  def create
    begin
      @event = current_user.events.new(event_params)
      @event.register
      redirect_to @event
    rescue ActiveRecord::RecordInvalid
      render :new
    end
  end

  private

  def event_params
    params.require(:event).permit(:name, :duration)
  end
end