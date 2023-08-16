class CreateAddressService
  attr_reader :user, :serialized_address

  def initialize(user, serialized_address)
    @user = user
    @serialized_address = serialized_address
  end

  def save
    address = user.addresses.new(serialized_address)

    if address.save
      { status: :created, data: address }
    else
      raise CepExceptions::AddressValidationError, address.errors.full_messages.to_sentence
    end
  end
end
