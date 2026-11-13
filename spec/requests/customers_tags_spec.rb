require "rails_helper"

RSpec.describe "Customers::TagsController", type: :request do
  describe "GET /customers/:id/tags" do
    let!(:user) { create(:user, email: "cut_index@example.com") }
    let!(:customer) { create(:customer, user: user, name: "Test Customer") }
    let!(:other_customer) { create(:customer, user: user, name: "Other Customer") }
    let!(:vip_tag) { create(:tag, name: "VIP", tag_type: Tag::CUSTOMER_STATUS) }
    let!(:prospect_tag) { create(:tag, name: "Prospect", tag_type: Tag::CUSTOMER_STATUS) }
    let!(:customer_tag1) { create(:customer_tag, customer: customer, tag: vip_tag) }
    let!(:customer_tag2) { create(:customer_tag, customer: customer, tag: prospect_tag) }
    let!(:other_customer_tag) { create(:customer_tag, customer: other_customer, tag: vip_tag) }

    before { sign_in user }

    it "returns tag names for the specified customer" do
      get "/customers/#{customer.id}/tags",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json).to be_an(Array)
      expect(json).to include("VIP", "Prospect")
      expect(json.size).to eq(2)
    end

    it "returns empty array when customer has no tags" do
      new_customer = create(:customer, user: user, name: "Empty Customer")

      get "/customers/#{new_customer.id}/tags",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json).to be_empty
    end
  end
end
