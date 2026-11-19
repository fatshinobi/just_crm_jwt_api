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

  describe "POST /opportunities/:id/tags" do
    let!(:user) { create(:user, email: "ot_create@example.com") }
    let!(:customer) { create(:customer, user: user, name: "Test Customer") }
    let!(:client) { create(:client, user: user, name: "Test Client") }
    let!(:opportunity) { create(:opportunity, customer: customer, client: client, user: user, title: "Test Opportunity") }

    before { sign_in user }

    it "creates tags and returns 201" do
      expect {
        post "/opportunities/#{opportunity.id}/tags",
          params: { tags: "Hot,Cold" }.to_json,
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

        expect(response).to have_http_status(:created)
      }.to change(Tag, :count).by(2)

      expect(opportunity.tags.pluck(:name)).to include("Hot", "Cold")
    end

    it "replaces existing tags" do
      existing_tag = create(:tag, name: "Old Tag", tag_type: Tag::OPPORTUNITY_STATUS)
      create(:opportunity_tag, opportunity: opportunity, tag: existing_tag)

      post "/opportunities/#{opportunity.id}/tags",
        params: { tags: "Hot" }.to_json,
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:created)

      expect(opportunity.tags.pluck(:name)).to include("Hot")
      expect(opportunity.tags.pluck(:name)).not_to include("Old Tag")
      expect(Tag.exists?(existing_tag.id)).to be(true)
    end

    it "uses find_or_create_by so tags are not duplicated" do
      existing_tag = create(:tag, name: "Hot", tag_type: Tag::OPPORTUNITY_STATUS)

      expect {
        post "/opportunities/#{opportunity.id}/tags",
          params: { tags: "Hot" }.to_json,
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }
      }.not_to change(Tag, :count)

      expect(opportunity.tags.pluck(:name)).to include("Hot")
    end

    it "skips blank tags" do
      expect {
        post "/opportunities/#{opportunity.id}/tags",
          params: { tags: "Hot,   ,, Cold" }.to_json,
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

        expect(response).to have_http_status(:created)
      }.to change(Tag, :count).by(2)
    end
  end
end
