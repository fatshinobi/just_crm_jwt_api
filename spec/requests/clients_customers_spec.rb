require "rails_helper"

RSpec.describe "Clients::CustomersController", type: :request do
  describe "GET /clients/customers/:client_id" do
    let!(:user) { create(:user, email: "cc_customers@example.com") }
    let!(:client) { create(:client, user: user, name: "Test Client") }
    let!(:customer1) { create(:customer, user: user, name: "Customer One") }
    let!(:customer2) { create(:customer, user: user, name: "Customer Two") }
    let!(:other_client) { create(:client, user: user, name: "Other Client") }
    let!(:other_customer) { create(:customer, user: user, name: "Other Customer") }
    let!(:cc1) { create(:client_customer, client: client, customer: customer1, role: "Manager") }
    let!(:cc2) { create(:client_customer, client: client, customer: customer2, role: "Admin") }
    let!(:other_cc) { create(:client_customer, client: other_client, customer: other_customer, role: "Manager") }

    before { sign_in user }

    it "returns customers linked to the specified client" do
      get "/clients/customers/#{client.id}",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json).to be_an(Array)
      ids = json.map { |c| c["customer_id"] }
      expect(ids).to include(customer1.id, customer2.id)
      expect(ids).not_to include(other_customer.id)
    end

    it "returns correct structure with customer_client element attributes" do
      get "/clients/customers/#{client.id}",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      cc_json = json.find { |c| c["customer_id"] == customer1.id }

      expect(cc_json["client_id"]).to eq(client.id)
      expect(cc_json["customer_id"]).to eq(customer1.id)
      expect(cc_json["role"]).to eq("Manager")
      expect(cc_json["name"]).to eq("Customer One")
    end

    it "returns empty array when client has no customers" do
      new_client = create(:client, user: user, name: "Empty Client")

      get "/clients/customers/#{new_client.id}",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json).to be_empty
    end
  end
end
