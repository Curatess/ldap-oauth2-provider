class AcmeKey < ApplicationRecord
  self.primary_key = 'token'

  def to_param
    token.parameterize
  end

end
