require "rails_helper"

RSpec.describe "Clients::AttachmentsController", type: :request do
  include FactoryBot::Syntax::Methods
  include Devise::Test::IntegrationHelpers

  describe "GET /clients/attachments/:client_id" do
    let!(:user) { create(:user) }
    let!(:client) { create(:client, user: user) }
    let!(:attachment) { create(:attachment, attachable: client, description: "Client attachment 1") }
    let!(:other_client) { create(:client, user: user, name: "Another Client") }
    let!(:empty_client) { create(:client, user: user, name: "Empty Client") }
    let!(:other_attachment) { create(:attachment, attachable: other_client, description: "Client attachment 2") }

    before { sign_in user }

    it "returns all attachments for the specified client" do
      get "/clients/attachments/#{client.id}",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json).to be_an(Array)
      ids = json.map { |a| a["id"] }
      expect(ids).to include(attachment.id)
      expect(ids).not_to include(other_attachment.id)
    end

    it "returns the correct attributes in the response" do
      get "/clients/attachments/#{client.id}",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      attachment_json = json.find { |a| a["id"] == attachment.id }

      expect(attachment_json["id"]).to eq(attachment.id)
      expect(attachment_json["description"]).to eq("Client attachment 1")
      expect(attachment_json["attachment_type"]).to eq(attachment.attachment_type)
      expect(attachment_json["customer_id"]).to eq(client.id)
      expect(attachment_json["uploaded_file_name"]).to be_nil
      expect(attachment_json["uploaded_file_url"]).to be_nil
    end

    context "when client has no attachments" do
      it "returns an empty array" do
        get "/clients/attachments/#{empty_client.id}",
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json).to be_an(Array)
        expect(json).to be_empty
      end
    end

    context "when client does not exist" do
      it "returns 404" do
        get "/clients/attachments/999999",
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
