class Api::V1::AddressesController < ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :clean_cep
  before_action :set_user

  def create
    begin
      fetch_service = FetchAddressService.new(@cep)
      fetch_result = fetch_service.call

      serialized_address = SerializeAddressService.new(fetch_result).serialize
      create_service = CreateAddressService.new(@user, serialized_address)
      result = create_service.save

      render json: result[:data], status: result[:status]

    rescue CepExceptions::InvalidCepFormat
      render json: { status: 400, message: I18n.t('errors.invalid_cep_format') }, status: :bad_request
    rescue CepExceptions::CepNotFound
      render json: { status: 404, message: I18n.t('errors.cep_not_found') }, status: :not_found
    rescue CepExceptions::DuplicateAddressError
      render json: { status: 409, message: I18n.t('errors.duplicate_address_error') }, status: :conflict
    rescue CepExceptions::ServiceError
      render json: { status: 503, message: I18n.t('errors.service_error') }, status: :service_unavailable
    rescue CepExceptions::TimeoutError
      render json: { status: 408, message: I18n.t('errors.timeout_error') }, status: :request_timeout
    rescue ActiveRecord::RecordNotFound
      render json: { status: 404, message: I18n.t('errors.user_not_found') }, status: :not_found
    rescue StandardError => e
      logger.error "Unhandled error: #{e}"
      render json: { status: 500, message: I18n.t('errors.something_went_wrong') }, status: :internal_server_error
    end
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
end
