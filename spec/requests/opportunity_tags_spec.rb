require "rails_helper"

RSpec.describe "OpportunityTagsController", type: :request do
  describe "GET /opportunity_tags" do
    let!(:user) { create(:user, email: "ot_index@example.com") }
    let!(:customer) { create(:customer, user: user, name: "Test Customer") }
    let!(:opportunity1) { create(:opportunity, user: user, customer: customer, title: "Opportunity 1") }
    let!(:opportunity2) { create(:opportunity, user: user, customer: customer, title: "Opportunity 2") }
    let!(:hot_tag) { create(:tag, name: "Hot", tag_type: Tag::OPPORTUNITY_STATUS) }
    let!(:cold_tag) { create(:tag, name: "Cold", tag_type: Tag::OPPORTUNITY_STATUS) }
    let!(:opportunity_tag1) { create(:opportunity_tag, opportunity: opportunity1, tag: hot_tag) }
    let!(:opportunity_tag2) { create(:opportunity_tag, opportunity: opportunity2, tag: hot_tag) }
    let!(:opportunity_tag3) { create(:opportunity_tag, opportunity: opportunity1, tag: cold_tag) }

    before { sign_in user }

    it "returns tag names with their opportunity counts grouped by tag" do
      get "/opportunity_tags",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json).to be_an(Array)
      counts = json.assoc("Hot")
      expect(counts).to eq(["Hot", 2])

      cold = json.assoc("Cold")
      expect(cold).to eq(["Cold", 1])
    end

    it "returns empty array when no opportunity_tags exist" do
      OpportunityTag.delete_all

      get "/opportunity_tags",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json).to be_empty
    end
  end
end
