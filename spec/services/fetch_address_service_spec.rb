require 'rails_helper'

RSpec.describe FetchAddressService do
  let(:valid_cep) { '01001000' }
  let(:invalid_cep) { '123456789' }
  let(:valid_response) { build(:address_response) }

  it 'fetches address for valid CEP' do
    stub_request(:get, "https://viacep.com.br/ws/#{valid_cep}/json").
      to_return(status: 200, body: valid_response.to_json)

    service = FetchAddressService.new(valid_cep)
    result = service.call

    expect(result).to eq(valid_response.with_indifferent_access)
  end

  it 'returns error for invalid CEP format' do
    service = FetchAddressService.new(invalid_cep)
    result = service.call

    expect(result[:status]).to eq(:bad_request)
    expect(result[:message]).to eq(I18n.t('errors.invalid_cep_format'))
  end

  it 'returns error when CEP is not found' do
    stub_request(:get, "https://viacep.com.br/ws/#{valid_cep}/json").
      to_return(status: 200, body: { 'erro' => true }.to_json)

    service = FetchAddressService.new(valid_cep)
    result = service.call

    expect(result[:status]).to eq(:not_found)
    expect(result[:message]).to eq(I18n.t('errors.cep_not_found'))
  end
end
