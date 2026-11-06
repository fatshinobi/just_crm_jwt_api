require "rails_helper"

RSpec.describe "Clients::TagsController", type: :request do
  describe "GET /clients/:id/tags" do
    let!(:user) { create(:user, email: "ct_index@example.com") }
    let!(:client) { create(:client, user: user, name: "Test Client") }
    let!(:other_client) { create(:client, user: user, name: "Other Client") }
    let!(:active_tag) { create(:tag, name: "Active", tag_type: Tag::CLIENT_STATUS) }
    let!(:prospect_tag) { create(:tag, name: "Prospect", tag_type: Tag::CLIENT_STATUS) }
    let!(:client_tag1) { create(:client_tag, client: client, tag: active_tag) }
    let!(:client_tag2) { create(:client_tag, client: client, tag: prospect_tag) }
    let!(:other_client_tag) { create(:client_tag, client: other_client, tag: active_tag) }

    before { sign_in user }

    it "returns tag names for the specified client" do
      get "/clients/#{client.id}/tags",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json).to be_an(Array)
      expect(json).to include("Active", "Prospect")
      expect(json.size).to eq(2)
    end

    it "returns empty array when client has no tags" do
      new_client = create(:client, user: user, name: "Empty Client")

      get "/clients/#{new_client.id}/tags",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json).to be_empty
    end
  end
end
