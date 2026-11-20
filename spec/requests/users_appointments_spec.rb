require "rails_helper"

RSpec.describe "Users::AppointmentsController", type: :request do
  describe "GET /users/:id/appointments" do
    let!(:user) { create(:user, email: "ua_index@example.com") }
    let!(:other_user) { create(:user, email: "other_ua@example.com") }
    let!(:customer) { create(:customer, user: user, name: "Test Customer") }
    let!(:client) { create(:client, user: user, name: "Test Client") }
    let!(:appt1) { create(:appointment, user: user, customer: customer, client: client, about: "First meeting") }
    let!(:appt2) { create(:appointment, user: user, customer: customer, client: client, about: "Second meeting") }
    let!(:other_appt) { create(:appointment, user: other_user, customer: customer, client: client, about: "Other meeting") }

    before { sign_in user }

    it "returns appointments for the specified user" do
      get "/users/#{user.id}/appointments",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json).to be_an(Array)
      ids = json.map { |a| a["id"] }
      expect(ids).to include(appt1.id, appt2.id)
      expect(ids).not_to include(other_appt.id)
    end

    it "returns correct structure with appointment attributes" do
      get "/users/#{user.id}/appointments",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      appt_json = json.find { |a| a["id"] == appt1.id }

      expect(appt_json["about"]).to eq("First meeting")
      expect(appt_json["user_id"]).to eq(user.id)
      expect(appt_json["customer_name"]).to eq("Test Customer")
      expect(appt_json["client_name"]).to eq("Test Client")
    end

    it "returns empty array when user has no appointments" do
      new_user = create(:user, email: "empty_ua@example.com")

      get "/users/#{new_user.id}/appointments",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json).to be_empty
    end
  end
end
