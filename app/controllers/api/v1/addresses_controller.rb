class Api::V1::AddressesController < ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :clean_cep
  before_action :set_user
  around_action :handle_errors

  def create
    fetch_service = FetchAddressService.new(@cep, @user)
    serialized_address = SerializeAddressService.new(fetch_service.call).serialize
    create_service = CreateAddressService.new(@user, serialized_address)

    @address = create_service.save

    render :create, status: :created
  end

  private

  def clean_cep
    @cep ||= address_params[:cep].to_s.gsub(/\D/, "")
  end

  def address_params
    params.require(:address).permit(:cep)
  end

  def set_user
    @user ||= User.find(params[:user_id])
  end

  def handle_errors
    yield
  rescue CepExceptions::InvalidCepFormat
    render_error(:bad_request, "errors.invalid_cep_format")
  rescue CepExceptions::CepNotFound
    render_error(:not_found, "errors.cep_not_found")
  rescue CepExceptions::ServiceError
    render_error(:service_unavailable, "errors.service_error")
  rescue CepExceptions::TimeoutError
    render_error(:request_timeout, "errors.timeout_error")
  rescue ActiveRecord::RecordNotFound
    render_error(:not_found, "errors.user_not_found")
  rescue CepExceptions::CepAlreadyAssociatedError => e
    @associated_address = e.address
    render :already_associated_error, status: :unprocessable_entity
  rescue CepExceptions::AddressValidationError => e
    render_error(:unprocessable_entity, "errors.address_validation_error", errors: e.message)
  rescue StandardError => e
    logger.error "Unhandled error: #{e}"
    render_error(:internal_server_error, "errors.something_went_wrong")
  end

  def render_error(status, message_key, extras = {})
    render json: { status: Rack::Utils::SYMBOL_TO_STATUS_CODE[status], error: I18n.t(message_key, extras) }, status: status
  end
end
