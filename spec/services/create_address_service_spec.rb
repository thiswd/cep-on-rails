require "rails_helper"

RSpec.describe CreateAddressService do
  let(:user) { create(:user) }
  let(:serialized_address) { attributes_for(:address) }

  describe "#save" do
    context "when address is unique for a user" do
      it "successfully creates and saves the address" do
        service = CreateAddressService.new(user, serialized_address)
        expect { service.save }.to change { Address.count }.by(1)
      end
    end
  end
end
