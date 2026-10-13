require "rails_helper"

RSpec.describe "OpportunitiesController", type: :request do
  describe "GET /opportunities" do
    let!(:user) { create(:user) }
    let!(:customer) { create(:customer, user: user) }
    let!(:tag) { create(:tag, name: "Hot", tag_type: Tag::OPPORTUNITY_STATUS) }
    let!(:opportunity) { create(:opportunity, customer: customer, user: user, title: "Big Deal") }
    let!(:other_opportunity) { create(:opportunity, customer: customer, user: user, title: "Small Deal") }
    let!(:opportunity_tag) { create(:opportunity_tag, opportunity: opportunity, tag: tag) }

    before { sign_in user }

    it "returns all opportunities serialized with OpportunityElementResource" do
      get "/opportunities",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      ids = json.map { |o| o["id"] }

      expect(ids).to include(opportunity.id, other_opportunity.id)
    end

    it "returns the correct attributes in the response" do
      get "/opportunities",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      opp_json = json.find { |o| o["id"] == opportunity.id }

      expect(opp_json["id"]).to eq(opportunity.id)
      expect(opp_json["title"]).to eq("Big Deal")
      expect(opp_json["description"]).to eq(opportunity.description)
      expect(opp_json["amount"]).to eq(opportunity.amount.to_s)
      expect(opp_json["stage"]).to eq(opportunity.stage)
      expect(opp_json["status"]).to eq(opportunity.status)
      expect(opp_json["customer_id"]).to eq(customer.id)
      expect(opp_json["user_id"]).to eq(user.id)
      expect(opp_json["user_name"]).to eq(user.name)
      expect(opp_json["customer_name"]).to eq(customer.name)
    end

    it "includes tags in the response" do
      get "/opportunities",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      opp_json = json.find { |o| o["id"] == opportunity.id }

      expect(opp_json["tags"]).to be_an(Array)
      expect(opp_json["tags"].length).to eq(1)
      expect(opp_json["tags"].first["name"]).to eq("Hot")
    end

    context "when filtering by tag" do
      it "returns only opportunities with the matching tag" do
        get "/opportunities?tag=Hot",
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        ids = json.map { |o| o["id"] }

        expect(ids).to include(opportunity.id)
        expect(ids).not_to include(other_opportunity.id)
      end
    end

    context "when searching by title" do
      it "returns only opportunities matching the search term" do
        get "/opportunities?search=Small",
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        ids = json.map { |o| o["id"] }

        expect(ids).to include(other_opportunity.id)
        expect(ids).not_to include(opportunity.id)
      end
    end

    context "when filtering by stage" do
      let!(:staged_opportunity) { create(:opportunity, customer: customer, user: user, title: "Staged Deal", stage: 2) }

      it "returns only opportunities with the matching stage" do
        get "/opportunities?stage=2",
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        ids = json.map { |o| o["id"] }

        expect(ids).to include(staged_opportunity.id)
        expect(ids).not_to include(opportunity.id)
        expect(ids).not_to include(other_opportunity.id)
      end
    end
  end
end
