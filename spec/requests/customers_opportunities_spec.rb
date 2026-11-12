require "rails_helper"

RSpec.describe "Customers::OpportunitiesController", type: :request do
  describe "GET /customers/:id/opportunities" do
    let!(:user) { create(:user, email: "cup_index@example.com") }
    let!(:customer) { create(:customer, user: user, name: "Test Customer") }
    let!(:client) { create(:client, user: user, name: "Test Client") }
    let!(:other_customer) { create(:customer, user: user, name: "Other Customer") }
    let!(:opp1) { create(:opportunity, customer: customer, client: client, user: user, title: "Opportunity One") }
    let!(:opp2) { create(:opportunity, customer: customer, client: client, user: user, title: "Opportunity Two") }
    let!(:other_opp) { create(:opportunity, customer: other_customer, client: client, user: user, title: "Other Opportunity") }

    before { sign_in user }

    it "returns opportunities for the specified customer" do
      get "/customers/#{customer.id}/opportunities",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json).to be_an(Array)
      ids = json.map { |o| o["id"] }
      expect(ids).to include(opp1.id, opp2.id)
      expect(ids).not_to include(other_opp.id)
    end

    it "returns correct structure with opportunity attributes" do
      get "/customers/#{customer.id}/opportunities",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      opp_json = json.find { |o| o["id"] == opp1.id }

      expect(opp_json["title"]).to eq("Opportunity One")
      expect(opp_json["customer_id"]).to eq(customer.id)
      expect(opp_json["customer_name"]).to eq("Test Customer")
      expect(opp_json["client_name"]).to eq("Test Client")
      expect(opp_json["user_name"]).to eq(user.name)
    end

    it "returns empty array when customer has no opportunities" do
      new_customer = create(:customer, user: user, name: "Empty Customer")

      get "/customers/#{new_customer.id}/opportunities",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json).to be_empty
    end
  end
end
