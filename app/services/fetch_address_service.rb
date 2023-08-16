require "net/http"
require "json"

class FetchAddressService
  attr_reader :cep, :user

  CEP_API_PATH = "https://viacep.com.br/ws/".freeze
  RESPONSE_FORMAT = "json".freeze
  HIFEN_POSITION = 5.freeze

  def initialize(cep, user)
    @cep = cep
    @user = user
  end

  def check_cep
    raise CepExceptions::InvalidCepFormat unless valid_cep_format?

    if cep_added
      raise CepExceptions::CepAlreadyAssociatedError.new(cep_added)
    end
  end

  def call
    response = Net::HTTP.get(uri_url)
    result = JSON.parse(response)

    if result['erro']
      raise CepExceptions::CepNotFound, I18n.t('errors.cep_not_found')
    else
      result
    end
  rescue Net::HTTPClientError, Net::HTTPServerError
    raise CepExceptions::ServiceError, I18n.t('errors.service_error')
  rescue Net::OpenTimeout, Timeout::Error
    raise CepExceptions::TimeoutError, I18n.t('errors.timeout_error')
  end

  private

  def uri_url
    URI("#{CEP_API_PATH}#{cep}/#{res_format}")
  end

  def valid_cep_format?
    cep =~ /^[0-9]{8}$/
  end

  def cep_added
    user.addresses.find_by(cep: add_hyphen_to_cep)
  end

  def add_hyphen_to_cep
    first_part = cep[0...HIFEN_POSITION]
    second_part = cep[HIFEN_POSITION...cep.length]
    "#{first_part}-#{second_part}"
  end
end
