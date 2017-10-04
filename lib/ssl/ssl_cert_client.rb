module SSLCerts

  class Client

    def self.create_certs

      require "#{Rails.root}/config/initializers/01_ldap_config"
      $ldap_settings ||= LDAP::Config.ldap_setup

      # Authenticate Client

      require 'openssl'

      private_key = OpenSSL::PKey::RSA.new(4096)

      # Staging server
      # endpoint = 'https://acme-staging.api.letsencrypt.org/directory'

      # Production server
      endpoint = 'https://acme-v01.api.letsencrypt.org/directory'


      require 'acme-client'
      client = Acme::Client.new(private_key: private_key, endpoint: endpoint, connection_options: { request: { open_timeout: 5, timeout: 5 } })

      registration = client.register(contact: "mailto:#{$ldap_settings['ssl_email']}")

      registration.agree_terms



      # Authorize for domain

      authorization = client.authorize(domain: $ldap_settings['ssl_domain'])

      puts "Authorization Status: #{authorization.status}"

      challenge = authorization.http01

      token = challenge.token

      thumbprint = challenge.file_content # => 'string token and JWK thumbprint'
      AcmeKey.create({ token: token, thumbprint: thumbprint })
      challenge.request_verification

      while authorization.verify_status == 'pending'
        sleep(2)
        puts "Verify Status: #{authorization.verify_status}"
      end


      unless authorization.verify_status == 'valid'
        puts "Not authorized to verify cert"
        puts authorization.http01.error
        false
      else

        # Obtain a Certificate

        # We're going to need a certificate signing request. If not explicitly
        # specified, the first name listed becomes the common name.
        csr = Acme::Client::CertificateRequest.new(names: [$ldap_settings['ssl_domain']])

        # # We can now request a certificate. You can pass anything that returns
        # # a valid DER encoded CSR when calling to_der on it. For example an
        # # OpenSSL::X509::Request should work too.
        certificate = client.new_certificate(csr) # => #<Acme::Client::Certificate ....>

        File.write("/etc/letsencrypt/live/#{$ldap_settings['ssl_domain']}/privkey.pem", certificate.request.private_key.to_pem)
        File.write("/etc/letsencrypt/live/#{$ldap_settings['ssl_domain']}/cert.pem", certificate.to_pem)
        File.write("/etc/letsencrypt/live/#{$ldap_settings['ssl_domain']}/chain.pem", certificate.chain_to_pem)
        File.write("/etc/letsencrypt/live/#{$ldap_settings['ssl_domain']}/fullchain.pem", certificate.fullchain_to_pem)

        true
      end

    end

  end

end
