require 'net/ldap'
require 'grape'

class TokenGenerator < TokenBase


  ACCESS_TOKEN_EXPIRATION = 3600
  REFRESH_TOKEN_EXPIRATION = 28800
  SECRET = $ldap_settings['jwt_secret']
  HASHING_ALGO = 'HS512'


  private_constant :ACCESS_TOKEN_EXPIRATION,
                   :REFRESH_TOKEN_EXPIRATION,
                   :SECRET,
                   :HASHING_ALGO


  attr_reader :access_token, :refresh_token, :token_type, :id


  def initialize
    @id = SecureRandom.uuid
    @access_token = nil
    @refresh_token = nil
    @errors = nil
    @status = nil
    @result = nil
  end

  def valid?
    self.errors.nil?
  end

  def authenticate(params)

    begin
      unless params['grant_type'] && params['grant_type'].downcase.strip == 'password'
        return handle_error('unsupported_grant_type')
      end
    end

    ldap = LDAP_Client.new
    result = ldap.authenticate(params)

    if result
      data = ldap.get_data(params)
      @access_token = construct_jwt(data, ACCESS_TOKEN_EXPIRATION)
      @refresh_token = construct_jwt(data, REFRESH_TOKEN_EXPIRATION)
      @token_type = 'JWT'
    else
      handle_error('Failed to authenticate')
    end

  end


  private

    def parameter_missing!(missing_param)
      missing_parameter = JSONAPI::Exceptions::ParameterMissing.new(missing_param)
      missing = JSONAPI::ErrorsOperationResult.new(missing_parameter.errors[0].code, missing_parameter.errors)
      missing_errors = { errors: missing.errors }
      error! missing_errors, 400
    end

    def construct_jwt(data, seconds_to_expiration)
      drift = 300
      payload = {
        iss: generate_issuer_from_host_name,
        jti: SecureRandom.uuid,
        exp: Time.now.to_i + seconds_to_expiration,
        nbf: Time.now.to_i - drift,
        uid: data[:employeeid],
        nme: data[:name],
        eml: data[:mail],
        phn: data[:telephonenumber],
        job: data[:title],
        oru: create_scopes(data[:distinguishedname][0]),
        scp: get_group_cns(data[:memberof]),
        smn: data[:samaccountname]
      }
      JWT.encode payload, SECRET, HASHING_ALGO
    end


    def generate_issuer_from_host_name
      $ldap_settings['ldap_hostname'].partition('.')[2]
    end


    def create_scopes(dn)
      scopes = []
      dn_array = dn.split(',')
      dn_array.each do |entry|
        entry = entry.strip
        if entry.downcase[0..1] == 'ou'
          scopes << entry.partition('=')[2]
        end
      end
      scopes
    end


    def get_group_cns(memberof)
      memberof.map do |entry|
        cn = entry.partition(',')[0]
        cn.partition('=')[2]
      end
    end

end
