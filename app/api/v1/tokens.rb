require 'jwt_errors'

module V1
  class Tokens < Grape::API

    include V1::Defaults

    resource :tokens do



      desc "Creates a set of tokens" do

        success code: 200, message: <<-NOTE
                  {
                    "data": {
                      "id": "e0717bae-886b-4a43-a833-fc55767fd9d0",
                      "type": "token-generators",
                      "links": {
                        "self": "/token-generators/e0717bae-886b-4a43-a833-fc55767fd9d0"
                      },
                      "attributes": {
                        "access-jwt": "headers.data.signature",
                        "token-type": "JWT",
                        "refresh-jwt": "headers.data.signature"
                      }
                    }
                  }
                NOTE
        failure [
          { code: 400, message: <<-NOTE
            {
              "errors": [
                {
                  "title": "Missing Parameter",
                  "detail": "The required parameter, username, is missing.",
                  "code": "106",
                  "status": "400"
                }
              ]
            }
            NOTE
          },
          { code: 401, message: <<-NOTE
            {
              "errors": [
                {
                  "title": "Unauthorized",
                  "detail": "Failed to authenticate",
                  "code": "401",
                  "status": "401"
                }
              ]
            }
            NOTE
          },
          { code: 415, message: <<-NOTE
            {
              "errors": [
                {
                  "title": "Unsupported media type",
                  "detail": "All requests that create or update must use the 'application/vnd.api+json' Content-Type. This request specified 'application/vnd.api+jso'.",
                  "code": "415",
                  "status": "415"
                }
              ]
            }
            NOTE
          },
          { code: 500, message: <<-NOTE
            {
              "errors": [
                {
                  "title": "Internal Server Error",
                  "detail": "Internal Server Error",
                  "code": "500",
                  "status": "500",
                  "meta": {
                    "exception": "Connection refused - connect(2) for 66.96.162.92:636",
                    "backtrace": [
                      "backtrace"
                    ]
                  }
                }
              ]
            }
            NOTE
          }
         ]

        headers "Content-Type" => {
                    description: "Should be set to 'application/vnd.api+json'",
                    required: true
            },
            "Accept" => {
              description: "Should be set to 'application/vnd.cfc-v1+json'",
              required: false
            }


      end

      post do

        body = JSON.parse(request.body.read)['data']['attributes']

        @generator = TokenGenerator.new
        @generator.authenticate(body)

        status 200 and return @generator if @generator.valid?
        status @generator.status.to_i
        error! @generator.result, status

      end








      desc "Refreshes the access token" do

        success code: 200, message: <<-NOTE
          {
            "data": {
              "id": "069c6d7a-f980-4d0c-a800-7d4032f06ce9",
              "type": "token-refreshers",
              "links": {
                "self": "/token-refreshers/069c6d7a-f980-4d0c-a800-7d4032f06ce9"
              },
              "attributes": {
                "access-token": "headers.data.signature",
                "token-type": "JWT"
              }
            }
          }
        NOTE
        failure [
          { code: 400, message: <<-NOTE
            {
              "errors": [
                {
                  "title": "Missing Parameter",
                  "detail": "The required parameter, refresh_token, is missing.",
                  "code": "106",
                  "status": "400"
                }
              ]
            }
            NOTE
          },
          { code: 401, message: <<-NOTE
            {
              "errors": [
                {
                  "title": "Unauthorized",
                  "detail": "Failed to authenticate",
                  "code": "401",
                  "status": "401"
                }
              ]
            }
            NOTE
          },
          { code: 415, message: <<-NOTE
            {
              "errors": [
                {
                  "title": "Unsupported media type",
                  "detail": "All requests that create or update must use the 'application/vnd.api+json' Content-Type. This request specified ''.",
                  "code": "415",
                  "status": "415"
                }
              ]
            }
            NOTE
          }
         ]

        headers "Content-Type" => {
                    description: "Should be set to 'application/vnd.api+json'",
                    required: true
            },
            "Accept" => {
              description: "Should be set to 'application/vnd.cfc-v1+json'",
              required: false
            }

      end

      put do

        body = JSON.parse(request.body.read)['data']['attributes']

        @refresher = TokenRefresher.new
        @refresher.refresh(body)

        status 200 and return @refresher if @refresher.valid?
        status @refresher.status.to_i
        error! @refresher.result, status

      end

    end

  end
end
