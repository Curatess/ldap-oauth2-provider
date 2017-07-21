require 'grape-swagger'

module API
  class Base < Grape::API
    mount V1::Base
    mount LetsEncrypt::Base # => '/:escaped_route', requirements: { escaped_route: /.*/ }

    add_swagger_documentation(
      api_version: "v1",
      hide_documentation_path: true,
      mount_path: "swagger_docs",
      hide_format: true,
      doc_version: '1.0.0',
      info: {
        title: "LDAP OAuth2 Provider"
      }
    )

  end
end
