namespace :ssl do
  desc "Check if certs need to be renewed"
  task renew: :environment do
    SslCertCheckerWorker.perform_async
  end
end
