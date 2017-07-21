require "#{Rails.root}/lib/ssl/ssl_cert_creation"

class SslCertInitializerWorker
  include Sidekiq::Worker

  def perform
    SSLCerts::Creator.write_cert_if_necessary
  end
end
