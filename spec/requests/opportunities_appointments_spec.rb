require "rails_helper"

RSpec.describe "Opportunities::AppointmentsController", type: :request do
  describe "GET /opportunities/:opportunity_id/appointments" do
    let!(:user) { create(:user, email: "oa_index@example.com") }
    let!(:customer) { create(:customer, user: user, name: "Test Customer") }
    let!(:client) { create(:client, user: user, name: "Test Client") }
    let!(:opportunity) { create(:opportunity, customer: customer, client: client, user: user, title: "Test Opportunity") }
    let!(:other_opportunity) { create(:opportunity, customer: customer, client: client, user: user, title: "Other Opportunity") }
    let!(:appt1) { create(:appointment, opportunity: opportunity, customer: customer, client: client, user: user, about: "First meeting") }
    let!(:appt2) { create(:appointment, opportunity: opportunity, customer: customer, client: client, user: user, about: "Second meeting") }
    let!(:other_appt) { create(:appointment, opportunity: other_opportunity, customer: customer, client: client, user: user, about: "Other meeting") }

    before { sign_in user }

    it "returns appointments for the specified opportunity" do
      get "/opportunities/#{opportunity.id}/appointments",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json).to be_an(Array)
      ids = json.map { |a| a["id"] }
      expect(ids).to include(appt1.id, appt2.id)
      expect(ids).not_to include(other_appt.id)
    end

    it "returns correct structure with appointment attributes" do
      get "/opportunities/#{opportunity.id}/appointments",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      appt_json = json.find { |a| a["id"] == appt1.id }

      expect(appt_json["about"]).to eq("First meeting")
      expect(appt_json["opportunity_id"]).to eq(opportunity.id)
      expect(appt_json["customer_name"]).to eq("Test Customer")
      expect(appt_json["client_name"]).to eq("Test Client")
      expect(appt_json["user_name"]).to eq(user.name)
    end

    it "returns empty array when opportunity has no appointments" do
      new_opportunity = create(:opportunity, customer: customer, client: client, user: user, title: "Empty Opportunity")

      get "/opportunities/#{new_opportunity.id}/appointments",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json).to be_empty
    end
  end
end
