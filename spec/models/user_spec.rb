require "rails_helper"

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }

  it "should have a valid jti" do
    user = build(:user)
    expect(user.jti).to be_present
  end

  describe "#for_display" do
    let(:user) { create(:user) }

    it "returns a hash with id and email of the user" do
      expect(user.for_display).to eq({
        id: user.id,
        email: user.email
      })
    end
  end
end
