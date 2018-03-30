require "#{Rails.root}/lib/ssl/ssl_cert_checker"
require "#{Rails.root}/lib/ssl/ssl_cert_creation"

class SslCertCheckerWorker
  include Sidekiq::Worker

  def perform
    logger.info "Checking if SSL certificates need to be renewed"
    if SSLCerts::Checker.certs_need_to_be_renewed?
      logger.info "Renewing certs"
      SSLCerts::Creator.overwrite_cert
      logger.info "Done renewing certs"
    else
      logger.info "Certs did not need to be renewed"
    end
  end
end
