require "rails_helper"

RSpec.describe "ClientsController", type: :request do
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
