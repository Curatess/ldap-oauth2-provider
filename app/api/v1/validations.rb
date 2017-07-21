require 'jwt_errors'

module V1
  class Validations < Grape::API

    include V1::Defaults

    resource :validations do


      desc "Validates an access token" do

        success code: 200, message: <<-NOTE
          {
            "data": {
              "id": "ea018663-80b4-4822-9ed5-3ea1ab6e692e",
              "type": "token-validators",
              "links": {
                "self": "/token-validators/ea018663-80b4-4822-9ed5-3ea1ab6e692e"
              },
              "attributes": {
                "valid?": true
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
                  "detail": "The required parameter, access_token, is missing.",
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

        @validator = TokenValidator.new
        @validator.validate(body)

        if @validator.valid?
          status 200
          return @validator
        else
          status @validator.status.to_i
          error! @validator.result, status
        end

      end





    end

  end
end
