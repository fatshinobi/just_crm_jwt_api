require "rails_helper"

RSpec.describe "ClientTagsController", type: :request do
  describe "GET /client_tags" do
    let!(:user) { create(:user, email: "ct_index@example.com") }
    let!(:client1) { create(:client, user: user, name: "Client 1") }
    let!(:client2) { create(:client, user: user, name: "Client 2") }
    let!(:active_tag) { create(:tag, name: "Active", tag_type: Tag::CLIENT_STATUS) }
    let!(:prospect_tag) { create(:tag, name: "Prospect", tag_type: Tag::CLIENT_STATUS) }
    let!(:client_tag1) { create(:client_tag, client: client1, tag: active_tag) }
    let!(:client_tag2) { create(:client_tag, client: client2, tag: active_tag) }
    let!(:client_tag3) { create(:client_tag, client: client1, tag: prospect_tag) }

    before { sign_in user }

    it "returns tag names with their client counts grouped by tag" do
      get "/client_tags",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json).to be_an(Array)
      counts = json.assoc("Active")
      expect(counts).to eq(["Active", 2])

      prospect = json.assoc("Prospect")
      expect(prospect).to eq(["Prospect", 1])
    end

    it "returns empty array when no client_tags exist" do
      ClientTag.delete_all

      get "/client_tags",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json).to be_empty
    end
  end
end
