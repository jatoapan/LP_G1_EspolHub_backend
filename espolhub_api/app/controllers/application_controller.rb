class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :bad_request

  protected

  def authenticate_seller!
    @current_seller = authenticate_with_http_token do |token, _options|
      # Simple token auth (en producción usar JWT)
      Seller.find_by(id: decode_token(token))
    end

    render_unauthorized unless @current_seller
  end

  def current_seller
    @current_seller
  end

  def render_success(data, status: :ok, meta: nil)
    response = { data: data }
    response[:meta] = meta if meta.present?
    render json: response, status: status
  end

  def render_error(errors, status: :unprocessable_entity)
    render json: { errors: Array(errors) }, status: status
  end

  def render_unauthorized
    render json: { error: "No autorizado" }, status: :unauthorized
  end

  private

  def not_found
    render json: { error: "Recurso no encontrado" }, status: :not_found
  end

  def bad_request(exception)
    render json: { error: exception.message }, status: :bad_request
  end

  def decode_token(token)
    # Implementación simple - usar JWT en producción
    Base64.decode64(token) rescue nil
  end
end