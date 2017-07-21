class TokenValidator < TokenBase

  attr_reader :id

  def initialize
    @id = SecureRandom.uuid
    @errors  = nil
    @status = nil
    @result = nil
    @token  = nil
  end

  def valid?
    self.errors.nil? || !@token.nil?
  end


  def validate(params)
    access_token = params['access_token']
    begin
      @token  = JWT.decode access_token, $ldap_settings['jwt_secret'], true, { algorithm: 'HS512' }
      self.status = '200'
    rescue JWT::ExpiredSignature, JWT::ImmatureSignature, JWT::InvalidIssuerError, JWT::VerificationError, JWT::InvalidSubError, JWT::InvalidJtiError, JWT::IncorrectAlgorithm, JWT::DecodeError
      handle_error('Failed to authenticate')
    end

  end


end
