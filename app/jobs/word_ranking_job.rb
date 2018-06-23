class WordRankingJob < ApplicationJob
  def perform(event_id)
    event    = Event.find_by(id: event_id)
    messages = event.messages
    event.update_columns(word_ranking: messages.get_ranking)
    messages.map(&:set_score)
  end
end
