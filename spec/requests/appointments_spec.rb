require "rails_helper"

RSpec.describe "AppointmentsController", type: :request do
  describe "GET /appointments/:id" do
    let!(:user) { create(:user) }
    let!(:customer) { create(:customer, user: user) }
    let!(:appointment) { create(:appointment, customer: customer, user: user) }

    before { sign_in user }

    it "returns the appointment serialized with AppointmentElementResource" do
      get "/appointments/#{appointment.id}",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json["id"]).to eq(appointment.id)
      expect(json["about"]).to eq(appointment.about)
      expect(json["communication_type"]).to eq(appointment.communication_type)
      expect(json["customer_id"]).to eq(customer.id)
      expect(json["user_id"]).to eq(user.id)
      expect(json["user_name"]).to eq(user.name)
      expect(json["customer_name"]).to eq(customer.name)
      expect(json["formatted_when"]).to be_a(String)
    end

    context "when appointment does not exist" do
      it "returns 404" do
        get "/appointments/999999",
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
