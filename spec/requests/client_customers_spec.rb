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

    it "creates a Role when role is provided" do
      expect {
        post "/client_customers",
          params: { client_id: client.id, customer_id: customer.id, role: "Manager" }.to_json,
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }
      }.to change(Role, :count).by(1)

      new_role = Role.find_by(name: "Manager")
      expect(new_role).to be_present
    end

    it "does not create a Role when role is not provided" do
      expect {
        post "/client_customers",
          params: { client_id: client.id, customer_id: customer.id }.to_json,
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }
      }.not_to change(Role, :count)
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

  describe "PATCH /client_customers/:id" do
    let!(:user) { create(:user, email: "cc_update@example.com") }
    let!(:client) { create(:client, user: user, name: "Test Client") }
    let!(:customer) { create(:customer, user: user, name: "Test Customer") }
    let!(:client_customer) { create(:client_customer, client: client, customer: customer, role: "Manager") }

    before { sign_in user }

    it "updates the role and returns the serialized response with ClientCustomerResource" do
      patch "/client_customers/#{client_customer.id}",
        params: { role: "Admin" }.to_json,
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["id"]).to eq(client_customer.id)
      expect(json["role"]).to eq("Admin")

      client_customer.reload
      expect(client_customer.role).to eq("Admin")
    end

    it "creates a Role when a new role is provided" do
      expect {
        patch "/client_customers/#{client_customer.id}",
          params: { role: "Supervisor" }.to_json,
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }
      }.to change(Role, :count).by(1)

      new_role = Role.find_by(name: "Supervisor")
      expect(new_role).to be_present
    end

    context "when client_customer does not exist" do
      it "returns 404" do
        patch "/client_customers/999999",
          params: { role: "Admin" }.to_json,
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /client_customers/:id" do
    let!(:user) { create(:user, email: "cc_show@example.com") }
    let!(:client) { create(:client, user: user, name: "Test Client") }
    let!(:customer) { create(:customer, user: user, name: "Test Customer") }
    let!(:client_customer) { create(:client_customer, client: client, customer: customer, role: "Manager") }

    before { sign_in user }

    it "returns the client-customer link serialized with ClientCustomerResource" do
      get "/client_customers/#{client_customer.id}",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json["id"]).to eq(client_customer.id)
      expect(json["client_id"]).to eq(client.id)
      expect(json["customer_id"]).to eq(customer.id)
      expect(json["role"]).to eq("Manager")
      expect(json["client_name"]).to eq("Test Client")
      expect(json["customer_name"]).to eq("Test Customer")
    end

    context "when client_customer does not exist" do
      it "returns 404" do
        get "/client_customers/999999",
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
