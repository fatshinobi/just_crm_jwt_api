require "rails_helper"

RSpec.describe "ClientCustomersController", type: :request do
  describe "POST /client_customers" do
    let!(:user) { create(:user, email: "cc_create@example.com") }
    let!(:client) { create(:client, user: user, name: "Test Client") }
    let!(:customer) { create(:customer, user: user, name: "Test Customer") }

    before { sign_in user }

    it "creates a client-customer link and returns the serialized response with ClientCustomerResource" do
      post "/client_customers",
        params: { client_id: client.id, customer_id: customer.id, role: "Manager" }.to_json,
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:created)

      json = JSON.parse(response.body)

      expect(json["client_id"]).to eq(client.id)
      expect(json["customer_id"]).to eq(customer.id)
      expect(json["role"]).to eq("Manager")
    end

    context "when required params are missing" do
      it "returns 422 with errors" do
        post "/client_customers",
          params: { client_id: nil, customer_id: nil }.to_json,
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

        expect(response).to have_http_status(:unprocessable_content)

        json = JSON.parse(response.body)
        expect(json["errors"]).to be_an(Array)
      end
    end
  end
end
