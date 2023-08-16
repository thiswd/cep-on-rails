require "rails_helper"

RSpec.describe Address, type: :model do
  it { should belong_to(:user) }

  it { should validate_presence_of(:cep) }
  it { should validate_presence_of(:street_name) }
  it { should validate_presence_of(:complement) }
  it { should validate_presence_of(:neighborhood) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:state) }

  describe "uniqueness validation" do
    subject { create(:address) }
    it { should validate_uniqueness_of(:cep).scoped_to(:user_id).case_insensitive.with_message(I18n.t("errors.duplicate_address_error")) }
  end

  describe "valid address" do
    let(:user) { create(:user) }
    let(:address) { build(:address, user: user) }

    it "is valid with valid attributes" do
      expect(address).to be_valid
    end
  end

  describe "invalid address" do
    let(:user) { create(:user) }
    let(:address) { build(:address, user: user, cep: nil) }

    it "is not valid without a cep" do
      expect(address).not_to be_valid
    end
  end
end
