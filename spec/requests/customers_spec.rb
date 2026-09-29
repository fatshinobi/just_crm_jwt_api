require "rails_helper"

RSpec.describe "CustomersController", type: :request do
  describe "GET /customers/:id" do
    let!(:user) { create(:user) }
    let!(:customer) { create(:customer, user: user) }

    before { sign_in user }

    it "returns the customer serialized with CustomerShowResource" do
      get "/customers/#{customer.id}",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json["id"]).to eq(customer.id)
      expect(json["name"]).to eq(customer.name)
      expect(json["email"]).to eq(customer.email)
      expect(json["phone"]).to eq(customer.phone)
      expect(json["address"]).to eq(customer.address)
      expect(json["about"]).to eq(customer.about)
      expect(json["user_id"]).to eq(customer.user_id)
      expect(json["user_name"]).to eq(user.name)
      expect(json["avatar_url"]).to be_nil
    end

    context "when customer does not exist" do
      it "returns 404" do
        get "/customers/999999",
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
