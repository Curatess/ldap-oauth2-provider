module V1
  class Base < Grape::API
    mount V1::Tokens
    mount V1::Validations
  end
end
