class ApplicationController < ActionController::Base
  AUTH_KEY_HEADER_KEY = "X-Authentication-Key"
  before_filter :validate_json_format, :validate_user_agent, :validate_content_type, :set_content_type
  rescue_from Exception, with: :handle_exception
  
  protected
  
  def validate_json_format
    return head(:unsupported_media_type) unless request.format.json?
  end
  
  def validate_user_agent
    if !["Recipes iPhone", "Recipes Android"].include?(request.headers["User-Agent"])
      return head(:bad_request)
    end
  end
  
  def validate_content_type
    if (request.post? || request.put?) && request.headers["Content-Type"] != "application/json"
      return head(:unsupported_media_type)
    end
  end
  
  def set_content_type
    response.content_type = "application/json"
  end
  
  def validate_auth_key
    @cook = Cook.find_by_auth_key(request.headers[AUTH_KEY_HEADER_KEY])
    return head(:unauthorized) if @cook.nil?
  end
  
  def handle_exception(exception)
		logger.error "#{exception.message}\n#{exception.backtrace.join("\n")}"
    render json: {error: "A problem has occurred."}, status: :internal_server_error
    return
  end
end
