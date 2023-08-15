require "rails_helper"

RSpec.describe "Api::V1::Authentication", type: :request do
  let(:user) { create(:user) }

  describe "POST /api/v1/sign_in" do
    context "with valid credentials" do
      before do
        post "/api/v1/sign_in", params: {
          api_v1_user: {
            email: user.email,
            password: user.password
          }
        }
      end

      it "returns a 200 status code" do
        expect(response).to have_http_status(201)
      end

      it "returns a JWT token" do
        expect(JSON.parse(response.body)["token"]).to be_present
      end
    end

    context "with invalid credentials" do
      before do
        post "/api/v1/sign_in", params: {
          api_v1_user: {
            email: user.email,
            password: "wrongpassword"
          }
        }
      end

      it "returns a 401 status code" do
        expect(response).to have_http_status(401)
      end
    end
  end
end
