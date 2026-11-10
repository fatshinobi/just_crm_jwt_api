require "rails_helper"

RSpec.describe "Customers::ClientsController", type: :request do
  describe "GET /customers/clients/:customer_id" do
    let!(:user) { create(:user, email: "cuc_index@example.com") }
    let!(:customer) { create(:customer, user: user, name: "Test Customer") }
    let!(:client1) { create(:client, user: user, name: "Client One") }
    let!(:client2) { create(:client, user: user, name: "Client Two") }
    let!(:other_customer) { create(:customer, user: user, name: "Other Customer") }
    let!(:other_client) { create(:client, user: user, name: "Other Client") }
    let!(:cc1) { create(:client_customer, customer: customer, client: client1, role: "Manager") }
    let!(:cc2) { create(:client_customer, customer: customer, client: client2, role: "Admin") }
    let!(:other_cc) { create(:client_customer, customer: other_customer, client: other_client, role: "Manager") }

    before { sign_in user }

    it "returns clients linked to the specified customer" do
      get "/customers/clients/#{customer.id}",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json).to be_an(Array)
      ids = json.map { |c| c["client_id"] }
      expect(ids).to include(client1.id, client2.id)
      expect(ids).not_to include(other_client.id)
    end

    it "returns correct structure with client_customer element attributes" do
      get "/customers/clients/#{customer.id}",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      cc_json = json.find { |c| c["client_id"] == client1.id }

      expect(cc_json["customer_id"]).to eq(customer.id)
      expect(cc_json["client_id"]).to eq(client1.id)
      expect(cc_json["role"]).to eq("Manager")
      expect(cc_json["name"]).to eq("Client One")
    end

    it "returns empty array when customer has no clients" do
      new_customer = create(:customer, user: user, name: "Empty Customer")

      get "/customers/clients/#{new_customer.id}",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json).to be_empty
    end
  end
end
