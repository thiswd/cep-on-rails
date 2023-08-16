module CepExceptions
  class InvalidCepFormat < StandardError; end
  class CepNotFound < StandardError; end
  class ServiceError < StandardError; end
  class TimeoutError < StandardError; end
  class DuplicateAddressError < StandardError; end
end
