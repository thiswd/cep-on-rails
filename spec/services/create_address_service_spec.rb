require 'rails_helper'

RSpec.describe CreateAddressService do
  let(:user) { create(:user) }
  let(:serialized_address) { attributes_for(:address) }

  describe '#save' do
    context 'when address is unique for a user' do
      it 'successfully creates and saves the address' do
        service = CreateAddressService.new(user, serialized_address)
        expect { service.save }.to change { Address.count }.by(1)
      end

      it 'returns status created' do
        service = CreateAddressService.new(user, serialized_address)
        result = service.save
        expect(result[:status]).to eq(:created)
      end
    end

    context 'when address is duplicate for a user' do
      before do
        create(:address, serialized_address.merge(user: user))
      end

      it 'raises a DuplicateAddressError' do
        service = CreateAddressService.new(user, serialized_address)
        expect { service.save }.to raise_error(CepExceptions::DuplicateAddressError)
      end
    end
  end
end
