class WordRankingJob
  include Sidekiq::Worker
  sidekiq_options queue: :default,
                  retry: 15

  def perform(event_id)
    event = Event.find_by(id: event_id)
    event.get_word_ranking
    event.messages.map(&:set_score)
    perform_again?(event)
  end

  private

  def perform_again?(event)
    # run every 20 minutes until event expires
    if event.session_expiry > Time.current
      WordRankingJob.perform_in(120, event.id)
    end
  end
end
