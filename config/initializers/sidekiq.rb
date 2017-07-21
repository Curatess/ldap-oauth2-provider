if defined?(Sidekiq)
  Sidekiq.configure_server do |config|
    config.on(:startup) do
      Rails.application.config.after_initialize do
        SslCertCheckerWorker.perform_in(10.seconds)
      end
    end
  end
end
