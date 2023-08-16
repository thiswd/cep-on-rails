class SerializeAddressService
  attr_reader :raw_address

  def initialize(raw_address)
    @raw_address = raw_address
  end

  def serialize
    {
      cep: raw_address["cep"],
      street_name: raw_address["logradouro"],
      complement: raw_address["complemento"],
      neighborhood: raw_address["bairro"],
      city: raw_address["localidade"],
      state: raw_address["uf"]
    }
  end

end
