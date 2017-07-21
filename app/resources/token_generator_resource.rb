class TokenGeneratorResource < JSONAPI::Resource

  attributes :access_token, :token_type, :refresh_token

end
