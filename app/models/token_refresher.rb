class TokenRefresher < TokenBase

  ACCESS_TOKEN_EXPIRATION = 3600
  REFRESH_TOKEN_EXPIRATION = 28800
  SECRET = $ldap_settings['jwt_secret']
  HASHING_ALGO = 'HS512'


  private_constant :ACCESS_TOKEN_EXPIRATION,
                   :REFRESH_TOKEN_EXPIRATION,
                   :SECRET,
                   :HASHING_ALGO

  attr_reader :id, :access_token, :token_type

  def initialize
    @id = SecureRandom.uuid
    @errors  = nil
    @status = nil
    @result = nil
    @token  = nil
  end


  def valid?
    self.errors.nil?
  end


  def refresh(params)

    refresh_token = params['refresh_token']

    begin

      unless params['grant_type'] && params['grant_type'].downcase.strip == 'refresh_token'
         return handle_error('unsupported_grant_type')
      end

    end

    begin

      token = JWT.decode refresh_token, $ldap_settings['jwt_secret'], true, { algorithm: 'HS512' }
      self.status = '200'

      @access_token = construct_access_jwt_from_refresh_jwt(token[0], ACCESS_TOKEN_EXPIRATION)
      @token_type = 'JWT'

    rescue JWT::ExpiredSignature, JWT::ImmatureSignature, JWT::InvalidIssuerError, JWT::VerificationError, JWT::InvalidSubError, JWT::InvalidJtiError, JWT::IncorrectAlgorithm, JWT::DecodeError
      handle_error('Failed to authenticate')
    end

  end


    private


      def construct_access_jwt_from_refresh_jwt(refresh_token, seconds_to_expiration)
        access_token = refresh_token.dup
        drift = 300
        access_token['jti'] = SecureRandom.uuid
        access_token['exp'] = Time.now.to_i + seconds_to_expiration
        access_token['nbf'] = Time.now.to_i - drift
        JWT.encode access_token, SECRET, HASHING_ALGO
      end

end
