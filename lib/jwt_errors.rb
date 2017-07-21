module JSONAPI
  UNAUTHORIZED = '401'
  module Exceptions
    class Unauthorized < Error

      def initialize(name, error_object_overrides = {})
        @name = name
        super(error_object_overrides)
      end

      def name
        @name
      end

      def name=(new_name)
        @name = new_name
      end

      def errors
        [create_error_object(code: JSONAPI::UNAUTHORIZED,
                             status: :unauthorized,
                             title: I18n.translate('jsonapi-resources.exceptions.unauthorized.title',
                                                   default: 'Unauthorized'),
                             detail: I18n.translate('jsonapi-resources.exceptions.unauthorized.detail',
                                                    default: "#{self.name}" ))]
      end

    end
  end
end
