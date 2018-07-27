require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module MicStand
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.eager_load_paths << Rails.root.join('lib')

    config.active_job.queue_adapter = :sidekiq
  end
end
