require "#{Rails.root}/lib/ssl/ssl_cert_checker"
require "#{Rails.root}/lib/ssl/ssl_cert_creation"

class SslCertCheckerWorker
  include Sidekiq::Worker

  def perform
    puts "Checking if SSL certificates need to be renewed"
    if SSLCerts::Checker.certs_need_to_be_renewed?
      puts "Renewing certs"
      SSLCerts::Creator.overwrite_cert
      puts "Done renewing certs"
    else
      puts "Certs did not need to be renewed"
    end
  end
end
