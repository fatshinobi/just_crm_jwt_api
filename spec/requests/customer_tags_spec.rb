require "rails_helper"

RSpec.describe "CustomerTagsController", type: :request do
  describe "GET /customer_tags" do
    let!(:user) { create(:user, email: "ct_customer_index@example.com") }
    let!(:customer1) { create(:customer, user: user, name: "Customer 1") }
    let!(:customer2) { create(:customer, user: user, name: "Customer 2") }
    let!(:vip_tag) { create(:tag, name: "VIP", tag_type: Tag::CUSTOMER_STATUS) }
    let!(:prospect_tag) { create(:tag, name: "Prospect", tag_type: Tag::CUSTOMER_STATUS) }
    let!(:customer_tag1) { create(:customer_tag, customer: customer1, tag: vip_tag) }
    let!(:customer_tag2) { create(:customer_tag, customer: customer2, tag: vip_tag) }
    let!(:customer_tag3) { create(:customer_tag, customer: customer1, tag: prospect_tag) }

    before { sign_in user }

    it "returns tag names with their customer counts grouped by tag" do
      get "/customer_tags",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json).to be_an(Array)
      counts = json.assoc("VIP")
      expect(counts).to eq(["VIP", 2])

      prospect = json.assoc("Prospect")
      expect(prospect).to eq(["Prospect", 1])
    end

    it "returns empty array when no customer_tags exist" do
      CustomerTag.delete_all

      get "/customer_tags",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json).to be_empty
    end
  end
end
