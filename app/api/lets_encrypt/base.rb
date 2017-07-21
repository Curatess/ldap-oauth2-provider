module LetsEncrypt
  class Base < Grape::API
    mount LetsEncrypt::CertKey
  end
end
