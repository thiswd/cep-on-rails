require 'rails_helper'

RSpec.describe FetchAddressService do
  let(:user) { create(:user) }
  let(:valid_cep) { '01001000' }
  let(:invalid_cep) { '123456789' }
  let(:valid_response) { build(:address_response) }

  it 'fetches address for valid CEP' do
    stub_request(:get, "https://viacep.com.br/ws/#{valid_cep}/json").
      to_return(status: 200, body: valid_response.to_json)

    service = FetchAddressService.new(valid_cep, user)
    result = service.call

    expect(result).to eq(valid_response.with_indifferent_access)
  end

  it 'raises InvalidCepFormat error for invalid CEP' do
    service = FetchAddressService.new(invalid_cep, user)
    expect { service.call }.to raise_error(CepExceptions::InvalidCepFormat)
  end

  context 'when CEP is not found' do
    let(:not_found_cep) { '99999999' }

    before do
      stub_request(:get, "https://viacep.com.br/ws/#{not_found_cep}/json")
        .to_return(body: '{"erro": true}', status: 200)
    end

    it 'raises CepNotFound error' do
      service = FetchAddressService.new(not_found_cep, user)
      expect { service.call }.to raise_error(CepExceptions::CepNotFound)
    end
  end
end
