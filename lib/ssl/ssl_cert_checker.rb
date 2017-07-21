# require "#{Rails.root}/config/ldap_config.yml"

module SSLCerts

  class Checker

    CERT_FILES = ['privkey.pem', 'cert.pem', 'chain.pem', 'fullchain.pem']

    def self.certs_need_to_be_renewed?
      @@cert_files = self.build_cert_paths
      certs_empty? || certs_expired?
    end

    def self.certs_empty?
      @@cert_files = self.build_cert_paths
      @@cert_files.any? { |file| File.size?(file).nil? }
    end

    def self.certs_expired?
      @@cert_files = self.build_cert_paths
      @@cert_files.any? { |file| Time.now > File.mtime(file) + 60.days }
    end

    def self.build_cert_paths
      LDAP::Config.ldap_setup if !$ldap_settings
      CERT_FILES.map { |file| "/etc/letsencrypt/live/#{$ldap_settings['ssl_domain']}/" + file }
    end

  end

end
