require "net/http"
require "json"

class FetchAddressService
  attr_reader :cep, :user

  CEP_API_PATH = "https://viacep.com.br/ws/".freeze
  RESPONSE_FORMAT = "json".freeze
  HIFEN_POSITION = 5

  def initialize(cep, user)
    @cep = cep
    @user = user
  end

  def call
    check_cep

    Rails.cache.fetch(cep, expires_in: 1.day) { fetch_cep }
  rescue Net::HTTPClientError, Net::HTTPServerError
    raise CepExceptions::ServiceError, I18n.t("errors.service_error")
  rescue Net::OpenTimeout, Timeout::Error
    raise CepExceptions::TimeoutError, I18n.t("errors.timeout_error")
  end

  private

    def check_cep
      raise CepExceptions::InvalidCepFormat unless valid_cep_format?

      if cep_added
        raise CepExceptions::CepAlreadyAssociatedError, cep_added
      end
    end

    def fetch_cep
      response = Net::HTTP.get(uri_url)
      result = JSON.parse(response)

      if result["erro"]
        raise CepExceptions::CepNotFound, I18n.t("errors.cep_not_found")
      else
        add_to_cache(result)
        result
      end
    end

    def uri_url
      URI("#{CEP_API_PATH}#{cep}/#{RESPONSE_FORMAT}")
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

    def add_to_cache(result)
      Rails.cache.write(cep, result, expires_in: 1.day)
    end
end
