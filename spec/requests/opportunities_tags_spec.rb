require "rails_helper"

RSpec.describe "Opportunities::TagsController", type: :request do
  describe "GET /opportunities/:id/tags" do
    let!(:user) { create(:user, email: "ot_index@example.com") }
    let!(:customer) { create(:customer, user: user, name: "Test Customer") }
    let!(:client) { create(:client, user: user, name: "Test Client") }
    let!(:opportunity) { create(:opportunity, customer: customer, client: client, user: user, title: "Test Opportunity") }
    let!(:other_opportunity) { create(:opportunity, customer: customer, client: client, user: user, title: "Other Opportunity") }
    let!(:hot_tag) { create(:tag, name: "Hot", tag_type: Tag::OPPORTUNITY_STATUS) }
    let!(:cold_tag) { create(:tag, name: "Cold", tag_type: Tag::OPPORTUNITY_STATUS) }
    let!(:opportunity_tag1) { create(:opportunity_tag, opportunity: opportunity, tag: hot_tag) }
    let!(:opportunity_tag2) { create(:opportunity_tag, opportunity: opportunity, tag: cold_tag) }
    let!(:other_opportunity_tag) { create(:opportunity_tag, opportunity: other_opportunity, tag: hot_tag) }

    before { sign_in user }

    it "returns tag names for the specified opportunity" do
      get "/opportunities/#{opportunity.id}/tags",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json).to be_an(Array)
      expect(json).to include("Hot", "Cold")
      expect(json.size).to eq(2)
    end

    it "returns empty array when opportunity has no tags" do
      new_opportunity = create(:opportunity, customer: customer, client: client, user: user, title: "Empty Opportunity")

      get "/opportunities/#{new_opportunity.id}/tags",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json).to be_empty
    end
  end
end
