require "rails_helper"

RSpec.describe "CatalogsController", type: :request do
  describe "GET /catalogs/users" do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user, name: "Admin User", email: "admin@example.com") }

    before { sign_in user }

    it "returns all users as key-value pairs" do
      get "/catalogs/users",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json).to be_an(Array)
      expect(json.length).to eq(2)

      keys = json.map { |u| u["key"] }
      expect(keys).to include(user.id, other_user.id)

      values = json.map { |u| u["value"] }
      expect(values).to include(user.name, "Admin User")
    end

    it "returns correct structure with key and value" do
      get "/catalogs/users",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      user_json = json.find { |u| u["key"] == user.id }

      expect(user_json["key"]).to eq(user.id)
      expect(user_json["value"]).to eq(user.name)
    end
  end

  describe "GET /catalogs/clients_by_customer/:customer_id" do
    let!(:user) { create(:user) }
    let!(:customer) { create(:customer, user: user) }
    let!(:linked_client) { create(:client, user: user, name: "Linked Client") }
    let!(:unlinked_client) { create(:client, user: user, name: "Unlinked Client") }
    let!(:client_customer) { create(:client_customer, client: linked_client, customer: customer) }

    before { sign_in user }

    it "returns clients not yet linked to the customer" do
      get "/catalogs/clients_by_customer/#{customer.id}",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json).to be_an(Array)
      keys = json.map { |c| c["key"] }
      expect(keys).to include(unlinked_client.id)
      expect(keys).not_to include(linked_client.id)

      values = json.map { |c| c["value"] }
      expect(values).to include("Unlinked Client")
      expect(values).not_to include("Linked Client")
    end

    it "returns correct structure with key and value" do
      get "/catalogs/clients_by_customer/#{customer.id}",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      client_json = json.find { |c| c["key"] == unlinked_client.id }

      expect(client_json["key"]).to eq(unlinked_client.id)
      expect(client_json["value"]).to eq("Unlinked Client")
    end
  end
end
