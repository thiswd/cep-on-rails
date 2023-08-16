require "rails_helper"

RSpec.describe SerializeAddressService do
  let(:raw_address) do
    {
      "cep" => "12345678",
      "logradouro" => "Some Street",
      "complemento" => "Some Complement",
      "bairro" => "Some Neighborhood",
      "localidade" => "Some City",
      "uf" => "Some State"
    }
  end

  describe "#serialize" do
    it "returns serialized address data" do
      service = SerializeAddressService.new(raw_address)
      expected_result = {
        cep: "12345678",
        street_name: "Some Street",
        complement: "Some Complement",
        neighborhood: "Some Neighborhood",
        city: "Some City",
        state: "Some State"
      }

      expect(service.serialize).to eq(expected_result)
    end
  end
end
