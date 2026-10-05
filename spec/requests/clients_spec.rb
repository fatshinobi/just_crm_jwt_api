require "rails_helper"

RSpec.describe "ClientsController", type: :request do
  describe "GET /clients" do
    let!(:user) { create(:user) }
    let!(:tag) { create(:tag, name: "Prospect", tag_type: Tag::CLIENT_STATUS) }
    let!(:client) { create(:client, user: user) }
    let!(:other_client) { create(:client, user: user, name: "Another Client") }
    let!(:client_tag) { create(:client_tag, client: client, tag: tag) }

    before { sign_in user }

    it "returns all clients serialized with ClientResource" do
      get "/clients",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      ids = json.map { |c| c["id"] }

      expect(ids).to include(client.id, other_client.id)
    end

    it "returns the correct attributes in the response" do
      get "/clients",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      client_json = json.find { |c| c["id"] == client.id }

      expect(client_json["name"]).to eq(client.name)
      expect(client_json["about"]).to eq(client.about)
      expect(client_json["avatar_url"]).to be_nil
      expect(client_json["tags"]).to be_an(Array)
      tag_names = client_json["tags"].map { |t| t["name"] }
      expect(tag_names).to include("Prospect")
    end

    context "when filtering by tag" do
      it "returns only clients with the matching tag" do
        get "/clients?tag=Prospect",
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        ids = json.map { |c| c["id"] }

        expect(ids).to include(client.id)
        expect(ids).not_to include(other_client.id)
      end
    end

    context "when searching by name" do
      it "returns only clients matching the search term" do
        get "/clients?search=#{other_client.name}",
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        ids = json.map { |c| c["id"] }

        expect(ids).to include(other_client.id)
        expect(ids).not_to include(client.id)
      end
    end
  end

  describe "GET /clients/:id" do
    let!(:user) { create(:user) }
    let!(:client) { create(:client, user: user) }

    before { sign_in user }

    it "returns the client serialized with ClientShowResource" do
      get "/clients/#{client.id}",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json["id"]).to eq(client.id)
      expect(json["name"]).to eq(client.name)
      expect(json["email"]).to eq(client.email)
      expect(json["phone"]).to eq(client.phone)
      expect(json["social"]).to eq(client.social)
      expect(json["about"]).to eq(client.about)
      expect(json["user_id"]).to eq(client.user_id)
      expect(json["user_name"]).to eq(user.name)
      expect(json["avatar_url"]).to be_nil
    end

    context "when client does not exist" do
      it "returns 404" do
        get "/clients/999999",
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
