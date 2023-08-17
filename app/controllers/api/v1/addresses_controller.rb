class Api::V1::AddressesController < ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :clean_cep
  before_action :set_user

  def create
    begin
      fetch_service = FetchAddressService.new(@cep, @user)
      fetch_result = fetch_service.call

      serialized_address = SerializeAddressService.new(fetch_result).serialize

      create_service = CreateAddressService.new(@user, serialized_address)
      @address = create_service.save

      render :create, status: :created
    rescue CepExceptions::InvalidCepFormat
      render json: { status: 400, error: I18n.t("errors.invalid_cep_format") }, status: :bad_request
    rescue CepExceptions::CepNotFound
      render json: { status: 404, error: I18n.t("errors.cep_not_found") }, status: :not_found
    rescue CepExceptions::ServiceError
      render json: { status: 503, error: I18n.t("errors.service_error") }, status: :service_unavailable
    rescue CepExceptions::TimeoutError
      render json: { status: 408, error: I18n.t("errors.timeout_error") }, status: :request_timeout
    rescue ActiveRecord::RecordNotFound
      render json: { status: 404, error: I18n.t("errors.user_not_found") }, status: :not_found
    rescue CepExceptions::CepAlreadyAssociatedError => e
      @associated_address = e.address
      render :already_associated_error, status: :unprocessable_entity
    rescue CepExceptions::AddressValidationError => e
      render json: {
        status: 422, error: I18n.t("errors.address_validation_error", errors: e.message)
      }, status: :unprocessable_entity
    rescue StandardError => e
      logger.error "Unhandled error: #{e}"
      render json: { status: 500, error: I18n.t("errors.something_went_wrong") }, status: :internal_server_error
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
