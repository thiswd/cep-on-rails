require "rails_helper"

RSpec.describe "Seeds" do
  it "creates a user" do
    load Rails.root.join("db", "seeds.rb")
    expect(User.count).to eq(1)
  end
end
