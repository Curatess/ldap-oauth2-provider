# Read the file in tmp/settings
# Break up the file by YAML
# Set global variables to values in YAML

require 'yaml'

module LDAP

  class Config

    def self.ldap_setup

      ldap_data = YAML.load_file(File.join(Rails.root, 'config', "ldap_config.yml"))

      $ldap_settings = {}

      ldap_data['ldap_settings'].each do |key, value|
        $ldap_settings[key] = value
      end

      $ldap_settings

    end

  end

end

if Rails.env.production?
  LDAP::Config.ldap_setup
end
