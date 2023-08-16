module CepExceptions
  class InvalidCepFormat < StandardError; end
  class CepNotFound < StandardError; end
  class ServiceError < StandardError; end
  class TimeoutError < StandardError; end
  class AddressValidationError < StandardError; end

  class CepAlreadyAssociatedError < StandardError
    attr_reader :address

    def initialize(address)
      @address = address
      super
    end
  end
end
