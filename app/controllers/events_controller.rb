class EventsController < AuthorizedController
  def index
    @events = current_user.events.all
  end
end