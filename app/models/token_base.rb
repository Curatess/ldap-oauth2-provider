class TokenBase
  require 'jwt'
  require 'jwt_errors'
  require 'securerandom'

  def errors
    @errors
  end

  def errors=(new_errors)
    @errors = new_errors
  end

  def status
    @status
  end

  def status=(new_status)
    @status = new_status
  end

  def result
    @result
  end

  private

    def handle_error(error_name)
      error = JSONAPI::Exceptions::Unauthorized.new(error_name)
      self.status = error.errors[0].code
      self.errors = error.errors
      result = JSONAPI::ErrorsOperationResult.new(error.errors[0].code, error.errors)
      @result = { errors: result.errors }
    end

end
