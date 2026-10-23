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

  describe "GET /catalogs/customers_by_client/:client_id" do
    let!(:user) { create(:user) }
    let!(:client) { create(:client, user: user, name: "Main Client") }
    let!(:linked_customer) { create(:customer, user: user, name: "Linked Customer") }
    let!(:unlinked_customer) { create(:customer, user: user, name: "Unlinked Customer") }
    let!(:client_customer) { create(:client_customer, client: client, customer: linked_customer) }

    before { sign_in user }

    it "returns customers not yet linked to the client" do
      get "/catalogs/customers_by_client/#{client.id}",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json).to be_an(Array)
      keys = json.map { |c| c["key"] }
      expect(keys).to include(unlinked_customer.id)
      expect(keys).not_to include(linked_customer.id)

      values = json.map { |c| c["value"] }
      expect(values).to include("Unlinked Customer")
      expect(values).not_to include("Linked Customer")
    end

    it "returns correct structure with key and value" do
      get "/catalogs/customers_by_client/#{client.id}",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      customer_json = json.find { |c| c["key"] == unlinked_customer.id }

      expect(customer_json["key"]).to eq(unlinked_customer.id)
      expect(customer_json["value"]).to eq("Unlinked Customer")
    end
  end

  describe "GET /catalogs/clients_for_customer/:customer_id" do
    let!(:user) { create(:user) }
    let!(:customer) { create(:customer, user: user, name: "Main Customer") }
    let!(:linked_client) { create(:client, user: user, name: "Linked Client") }
    let!(:other_client) { create(:client, user: user, name: "Other Client") }
    let!(:client_customer) { create(:client_customer, client: linked_client, customer: customer) }

    before { sign_in user }

    it "returns only clients linked to the customer" do
      get "/catalogs/clients_for_customer/#{customer.id}",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json).to be_an(Array)
      keys = json.map { |c| c["key"] }
      expect(keys).to include(linked_client.id)
      expect(keys).not_to include(other_client.id)

      values = json.map { |c| c["value"] }
      expect(values).to include("Linked Client")
      expect(values).not_to include("Other Client")
    end

    it "returns correct structure with key and value" do
      get "/catalogs/clients_for_customer/#{customer.id}",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      client_json = json.find { |c| c["key"] == linked_client.id }

      expect(client_json["key"]).to eq(linked_client.id)
      expect(client_json["value"]).to eq("Linked Client")
    end
  end

  describe "GET /catalogs/customers_for_client/:client_id" do
    let!(:user) { create(:user) }
    let!(:client) { create(:client, user: user, name: "Main Client") }
    let!(:linked_customer) { create(:customer, user: user, name: "Linked Customer") }
    let!(:other_customer) { create(:customer, user: user, name: "Other Customer") }
    let!(:client_customer) { create(:client_customer, client: client, customer: linked_customer) }

    before { sign_in user }

    it "returns only customers linked to the client" do
      get "/catalogs/customers_for_client/#{client.id}",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json).to be_an(Array)
      keys = json.map { |c| c["key"] }
      expect(keys).to include(linked_customer.id)
      expect(keys).not_to include(other_customer.id)

      values = json.map { |c| c["value"] }
      expect(values).to include("Linked Customer")
      expect(values).not_to include("Other Customer")
    end

    it "returns correct structure with key and value" do
      get "/catalogs/customers_for_client/#{client.id}",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      customer_json = json.find { |c| c["key"] == linked_customer.id }

      expect(customer_json["key"]).to eq(linked_customer.id)
      expect(customer_json["value"]).to eq("Linked Customer")
    end
  end
end
