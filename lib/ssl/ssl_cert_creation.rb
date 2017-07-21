require "ssl/ssl_cert_client"
require "ssl/ssl_cert_checker"

# Any of these files don't exist
# Or if any of these files are empty
# Renew certs

module SSLCerts

  class Creator

    def self.write_cert_if_necessary
      if SSLCerts::Checker.certs_expired?
        created = SSLCerts::Client.create_certs
        puts "Certs created? #{created}"
      end
    end

    def self.overwrite_cert
      created = SSLCerts::Client.create_certs
    end

  end

end
