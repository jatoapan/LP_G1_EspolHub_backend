class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include Pundit::Authorization

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :bad_request
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def pundit_user
    current_seller
  end

  # Authenticate the current seller using JWT token
  # Expects Authorization header with Bearer token
  def authenticate_seller!
    token = extract_bearer_token

    unless token
      return render_error("Token de autenticación requerido", status: :unauthorized)
    end

    begin
      payload = Auth::TokenService.decode(token)

      # Verify it's an access token (not a refresh token)
      unless Auth::TokenService.access_token?(payload)
        return render_error("Token inválido", status: :unauthorized)
      end

      # Find and cache the seller
      seller_id = Auth::TokenService.seller_id_from_payload(payload)
      @current_seller = Seller.find(seller_id)
    rescue Auth::TokenService::ExpiredTokenError
      render_error("Token expirado, por favor inicia sesión nuevamente", status: :unauthorized)
    rescue Auth::TokenService::InvalidTokenError
      render_error("Token inválido o expirado", status: :unauthorized)
    rescue ActiveRecord::RecordNotFound
      render_error("Usuario no encontrado", status: :unauthorized)
    end
  end

  # Get the current authenticated seller
  #
  # @return [Seller, nil]
  attr_reader :current_seller

  # Render successful response with data
  #
  # @param data [Object] The response data
  # @param status [Symbol] HTTP status code
  # @param meta [Hash] Optional metadata
  def render_success(data, status: :ok, meta: nil)
    response = {data: data}
    response[:meta] = meta if meta.present?
    render json: response, status: status
  end

  # Render error response
  #
  # @param errors [String, Array] Error message(s)
  # @param status [Symbol] HTTP status code
  def render_error(errors, status: :unprocessable_entity)
    render json: {errors: Array(errors)}, status: status
  end

  # Render unauthorized response (deprecated - use render_error)
  def render_unauthorized
    render json: {error: "No autorizado"}, status: :unauthorized
  end

  private

  # Extract Bearer token from Authorization header
  #
  # @return [String, nil]
  def extract_bearer_token
    header = request.headers["Authorization"]
    return nil unless header&.start_with?("Bearer ")

    header.split(" ").last
  end

  # Handle 404 Not Found errors
  def not_found
    render json: {error: "Recurso no encontrado"}, status: :not_found
  end

  # Handle 400 Bad Request errors
  def bad_request(exception)
    render json: {error: exception.message}, status: :bad_request
  end

  # Handle Pundit authorization errors
  def user_not_authorized
    render json: {error: "No tienes permiso para realizar esta acción"}, status: :forbidden
  end
end

