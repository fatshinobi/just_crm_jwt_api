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

  describe "GET /clients/attachments/:client_id/:id" do
    let!(:user) { create(:user) }
    let!(:client) { create(:client, user: user) }
    let!(:attachment) { create(:attachment, attachable: client, description: "Single attachment") }

    before { sign_in user }

    it "returns the attachment serialized with ClientAttachmentElementResource" do
      get "/clients/attachments/#{client.id}/#{attachment.id}",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json["id"]).to eq(attachment.id)
      expect(json["description"]).to eq("Single attachment")
      expect(json["attachment_type"]).to eq(attachment.attachment_type)
      expect(json["customer_id"]).to eq(client.id)
      expect(json["uploaded_file_name"]).to be_nil
      expect(json["uploaded_file_url"]).to be_nil
    end

    context "when attachment does not exist" do
      it "returns 404" do
        get "/clients/attachments/#{client.id}/999999",
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /clients/attachments/:client_id" do
    let!(:user) { create(:user) }
    let!(:client) { create(:client, user: user) }

    before { sign_in user }

    it "creates an attachment and returns 201" do
      post "/clients/attachments/#{client.id}",
        params: { description: "New attachment" }.to_json,
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:created)

      json = JSON.parse(response.body)
      expect(json["message"]).to eq("Attachment created successfully")

      attachment = Attachment.find_by(attachable: client, description: "New attachment")
      expect(attachment).not_to be_nil
    end

    context "when description is missing" do
      it "returns 422 with errors" do
        allow_any_instance_of(Attachment).to receive(:save).and_return(false)
        allow_any_instance_of(Attachment).to receive_message_chain(:errors, :full_messages).and_return([ "Description can't be blank" ])

        post "/clients/attachments/#{client.id}",
          params: { description: nil }.to_json,
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

        expect(response).to have_http_status(:unprocessable_content)

        json = JSON.parse(response.body)
        expect(json["errors"]).to be_an(Array)
      end
    end

    context "when client does not exist" do
      it "returns 404" do
        post "/clients/attachments/999999",
          params: { description: "New attachment" }.to_json,
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
