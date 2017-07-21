module LetsEncrypt
  class CertKey < Grape::API

    resource do

      desc "Validate a challenge", hidden: true
      get '/:escaped_route/acme-challenge/:token', requirements: { escaped_route: /.well-known/ } do
        content_type "text/plain"
        @acme_key = AcmeKey.find(params[:token])
        @acme_key.thumbprint
      end

    end

  end
end
