require 'rails_helper'

RSpec.describe Api::V1::AddressesController, type: :controller do
  let(:user) { create(:user) }
  let(:cep) { '12345678' }
  let(:valid_attributes) { attributes_for(:address) }

  before do
    stub_request(:get, "https://viacep.com.br/ws/#{cep}/json")
      .to_return(body: valid_attributes.to_json, status: 200)
  end

  describe 'GET #find_by_cep' do
    context 'when user is found and CEP is valid' do
      before do
        get :find_by_cep, params: { user_id: user.id, cep: cep }
      end

      it 'returns http success' do
        expect(response).to have_http_status(:created)
      end

      it 'creates a new address for the user' do
        expect(user.addresses.count).to eq(1)
      end
    end
  end
end
