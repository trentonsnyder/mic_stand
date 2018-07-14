class InsightsController < AuthorizedController
  def index
    @messages = Message.joins(:event)
                       .where('events.user_id = ?', current_user.id)
                       .order('messages.score DESC')
                       .limit(15)
  end

  def all_messages_chart
    # TODO: figure out how to limit this
    render json: Message.joins(:event)
                        .where('events.user_id = ?', current_user.id)
                        .group("events.id, events.name")
                        .order("events.id")
                        .count
  end

  def keywords_chart
    render json: current_user.events
                             .order('created_at DESC')
                             .limit(10)
                             .map(&:word_ranking)
                             .inject{ |memo, el| memo.merge(el) { |k, old_v, new_v| old_v + new_v } }
                             .sort_by { |k, v| v }
                             .last(15)
  end
end
