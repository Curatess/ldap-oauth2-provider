module V1
  module Defaults
    extend ActiveSupport::Concern

    included do

      prefix 'api'
      version 'v1', using: :header, vendor: 'cfc'
      format        :json
      formatter     :json, Grape::Formatter::JSONAPIResources
      content_type  :json, 'application/vnd.api+json'

      before do
        unless json_api?
          invalid_media_type!
        end
      end

      helpers do

        def json_api?
          request.content_type == 'application/vnd.api+json'
        end

        def invalid_media_type!
          unsupported_media_type = JSONAPI::Exceptions::UnsupportedMediaTypeError.new(request.content_type)
          unsupported_media = JSONAPI::ErrorsOperationResult.new(unsupported_media_type.errors[0].code, unsupported_media_type.errors)
          media_errors = { errors: unsupported_media.errors}
          error! media_errors, 415
        end

        def parameter_missing!(missing_param)
          missing_parameter = JSONAPI::Exceptions::ParameterMissing.new(missing_param)
          missing = JSONAPI::ErrorsOperationResult.new(missing_parameter.errors[0].code, missing_parameter.errors)
          missing_errors = { errors: missing.errors }
          error! missing_errors, 400
        end

      end

      rescue_from ActiveRecord::RecordNotFound do |exception|
        params = env['api.endpoint'].params
        record_not_found = JSONAPI::Exceptions::RecordNotFound.new(params[:id])
        not_found = JSONAPI::ErrorsOperationResult.new(record_not_found.errors[0].code, record_not_found.errors)
        not_found_errors = { errors: not_found.errors }
        error! not_found_errors, 404
      end

      rescue_from Grape::Exceptions::ValidationErrors do |exception|
        missing_param = exception.message.split(' ')[0]
        parameter_missing!(missing_param)
      end

      rescue_from Net::LDAP::Error do |exception|
        error = JSONAPI::Exceptions::InternalServerError.new(exception)
        server_error = JSONAPI::ErrorsOperationResult.new(error.errors[0].code, error.errors)
        server_errors = { errors: server_error.errors }
        error! server_errors, 500
      end

    end
  end
end
