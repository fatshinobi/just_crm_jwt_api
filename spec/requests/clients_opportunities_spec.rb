require "rails_helper"

RSpec.describe "Clients::OpportunitiesController", type: :request do
  describe "GET /clients/:id/opportunities" do
    let!(:user) { create(:user, email: "co_index@example.com") }
    let!(:client) { create(:client, user: user, name: "Test Client") }
    let!(:customer) { create(:customer, user: user, name: "Test Customer") }
    let!(:other_client) { create(:client, user: user, name: "Other Client") }
    let!(:opp1) { create(:opportunity, client: client, customer: customer, user: user, title: "Opportunity One") }
    let!(:opp2) { create(:opportunity, client: client, customer: customer, user: user, title: "Opportunity Two") }
    let!(:other_opp) { create(:opportunity, client: other_client, customer: customer, user: user, title: "Other Opportunity") }

    before { sign_in user }

    it "returns opportunities for the specified client" do
      get "/clients/#{client.id}/opportunities",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json).to be_an(Array)
      ids = json.map { |o| o["id"] }
      expect(ids).to include(opp1.id, opp2.id)
      expect(ids).not_to include(other_opp.id)
    end

    it "returns correct structure with opportunity attributes" do
      get "/clients/#{client.id}/opportunities",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      opp_json = json.find { |o| o["id"] == opp1.id }

      expect(opp_json["title"]).to eq("Opportunity One")
      expect(opp_json["client_id"]).to eq(client.id)
      expect(opp_json["client_name"]).to eq("Test Client")
      expect(opp_json["customer_name"]).to eq("Test Customer")
      expect(opp_json["user_name"]).to eq(user.name)
    end

    it "returns empty array when client has no opportunities" do
      new_client = create(:client, user: user, name: "Empty Client")

      get "/clients/#{new_client.id}/opportunities",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json).to be_empty
    end
  end
end
