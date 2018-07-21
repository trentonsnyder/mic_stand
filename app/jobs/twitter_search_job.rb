class TwitterSearchJob
  include Sidekiq::Worker
  sidekiq_options queue: :default,
                  retry: 15

  def perform(event_id)
    event   = Event.find_by(id: event_id)
    client  = twitter_client
    results = client.search("#{event.hashtag} -filter:retweets AND -filter:replies", result_type: "recent")
    results.each do |t|
      # api premium search has datetime constraints, for now filter this side
      if t.created_at > event.created_at
        event.messages.create(
          tweet_id: t.id,
          body:     t.text,
          kind:     "tweet",
          from:     t.user.screen_name,
          likes:    t.favorite_count
        )
      end
    end
    perform_again?(event)
  end

  private

  def twitter_client
    Twitter::REST::Client.new do |config|
      config.consumer_key    = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret = ENV["TWITTER_CONSUMER_SECRET"]
    end
  end

  def perform_again?(event)
    # run every 10 minutes until event expires
    if event.session_expiry > Time.current
      TwitterSearchJob.perform_in(600, event.id)
    end
  end
end
