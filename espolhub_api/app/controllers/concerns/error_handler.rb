module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :handle_standard_error
    rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :handle_validation_error
    rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
  end

  private

  def handle_standard_error(exception)
    Rails.logger.error("#{exception.class}: #{exception.message}")
    Rails.logger.error(exception.backtrace.first(10).join("\n"))

    if Rails.env.development?
      render json: {
        error: exception.message,
        backtrace: exception.backtrace.first(5)
      }, status: :internal_server_error
    else
      render json: { error: "Error interno del servidor" }, status: :internal_server_error
    end
  end

  def handle_not_found(exception)
    render json: { error: "#{exception.model} no encontrado" }, status: :not_found
  end

  def handle_validation_error(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end

  def handle_parameter_missing(exception)
    render json: { error: "Parámetro requerido: #{exception.param}" }, status: :bad_request
  end
end
