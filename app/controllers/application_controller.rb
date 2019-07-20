class ApplicationController < ActionController::Base
  rescue_from StandardError, with: :render_internal_server_error
  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_fields
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActionController::BadRequest, with: :render_bad_request

  private

  def render_internal_server_error(exception)
    Rails.logger.error(exception.message)
    Rails.logger.error(exception.backtrace.join("\n"))

    render json: { error: 'Internal error.' }, status: :internal_server_error
  end

  def render_invalid_fields(exception)
    render json: { error: "The #{controller_name.singularize} can't be saved due to validation errors.",
                   details: exception.record.errors.full_messages }, status: :unprocessable_entity
  end

  def render_not_found(exception)
    render json: { error: 'The following resource was not found',
                   details: exception.message.split('[').first.strip }, status: :not_found
  end

  def render_bad_request
    render json: { error: 'Something went wrong with the request' }, status: :bad_request
  end

end
