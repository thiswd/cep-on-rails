require "net/http"
require "json"

class FetchAddressService
  attr_reader :cep, :res_format

  CEP_API_PATH = "https://viacep.com.br/ws/".freeze
  RESPONSE_FORMAT = "json".freeze

  def initialize(cep, res_format = RESPONSE_FORMAT)
    @cep = cep
    @res_format = res_format
  end

  def call
    raise CepExceptions::InvalidCepFormat unless valid_cep_format?

    fetch
  rescue Net::HTTPClientError, Net::HTTPServerError
    raise CepExceptions::ServiceError, I18n.t('errors.service_error')
  rescue Net::OpenTimeout, Timeout::Error
    raise CepExceptions::TimeoutError, I18n.t('errors.timeout_error')
  end

  private

  def fetch
    response = Net::HTTP.get(uri_url)
    result = JSON.parse(response)

    if result['erro']
      raise CepExceptions::CepNotFound, I18n.t('errors.cep_not_found')
    else
      result
    end
  end

  def uri_url
    URI("#{CEP_API_PATH}#{cep}/#{res_format}")
  end

  def valid_cep_format?
    cep =~ /^[0-9]{8}$/
  end
end
