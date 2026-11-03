require "rails_helper"

RSpec.describe "Clients::AppointmentsController", type: :request do
  describe "GET /clients/:id/appointments" do
    let!(:user) { create(:user, email: "ca_index@example.com") }
    let!(:client) { create(:client, user: user, name: "Test Client") }
    let!(:customer) { create(:customer, user: user, name: "Test Customer") }
    let!(:other_client) { create(:client, user: user, name: "Other Client") }
    let!(:appt1) { create(:appointment, client: client, customer: customer, user: user, about: "First meeting") }
    let!(:appt2) { create(:appointment, client: client, customer: customer, user: user, about: "Second meeting") }
    let!(:other_appt) { create(:appointment, client: other_client, customer: customer, user: user, about: "Other meeting") }

    before { sign_in user }

    it "returns appointments for the specified client" do
      get "/clients/#{client.id}/appointments",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json).to be_an(Array)
      ids = json.map { |a| a["id"] }
      expect(ids).to include(appt1.id, appt2.id)
      expect(ids).not_to include(other_appt.id)
    end

    it "returns correct structure with appointment attributes" do
      get "/clients/#{client.id}/appointments",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      appt_json = json.find { |a| a["id"] == appt1.id }

      expect(appt_json["about"]).to eq("First meeting")
      expect(appt_json["client_id"]).to eq(client.id)
      expect(appt_json["client_name"]).to eq("Test Client")
      expect(appt_json["customer_name"]).to eq("Test Customer")
      expect(appt_json["user_name"]).to eq(user.name)
    end

    it "returns empty array when client has no appointments" do
      new_client = create(:client, user: user, name: "Empty Client")

      get "/clients/#{new_client.id}/appointments",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json).to be_empty
    end
  end
end
