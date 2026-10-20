require "rails_helper"

RSpec.describe "AppointmentsController", type: :request do
  describe "POST /appointments" do
    let!(:user) { create(:user) }
    let!(:customer) { create(:customer, user: user) }

    before { sign_in user }

    it "creates an appointment and returns the serialized response with AppointmentResource" do
      post "/appointments",
        params: {
          about: "New meeting",
          when: "2024-07-20T14:00:00Z",
          communication_type: 0,
          status: 0,
          customer_id: customer.id,
          user_id: user.id
        }.to_json,
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:created)

      json = JSON.parse(response.body)

      expect(json["about"]).to eq("New meeting")
      expect(json["communication_type"]).to eq(0)
    end

    context "when required params are missing" do
      it "returns 422 with errors" do
        allow_any_instance_of(Appointment).to receive(:save).and_return(false)
        allow_any_instance_of(Appointment).to receive_message_chain(:errors, :full_messages).and_return([ "Customer must exist" ])

        post "/appointments",
          params: { about: "New meeting" }.to_json,
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

        expect(response).to have_http_status(:unprocessable_content)

        json = JSON.parse(response.body)
        expect(json["errors"]).to be_an(Array)
      end
    end
  end

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

  describe "PATCH /appointments/:id" do
    let!(:user) { create(:user) }
    let!(:customer) { create(:customer, user: user) }
    let!(:appointment) { create(:appointment, customer: customer, user: user, about: "Original about", communication_type: 0) }

    before { sign_in user }

    it "updates the appointment and returns the serialized response with AppointmentResource" do
      patch "/appointments/#{appointment.id}",
        params: { about: "Updated about", communication_type: 1 }.to_json,
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json["id"]).to eq(appointment.id)
      expect(json["about"]).to eq("Updated about")
      expect(json["communication_type"]).to eq(1)

      appointment.reload
      expect(appointment.about).to eq("Updated about")
      expect(appointment.communication_type).to eq(1)
    end

    context "when update fails" do
      it "returns 422 with errors" do
        allow_any_instance_of(Appointment).to receive(:update).and_return(false)
        allow_any_instance_of(Appointment).to receive_message_chain(:errors, :full_messages).and_return([ "About can't be blank" ])

        patch "/appointments/#{appointment.id}",
          params: { about: "" }.to_json,
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

        expect(response).to have_http_status(:unprocessable_content)

        json = JSON.parse(response.body)
        expect(json["errors"]).to be_an(Array)
      end
    end

    context "when appointment does not exist" do
      it "returns 404" do
        patch "/appointments/999999",
          params: { about: "Updated about" }.to_json,
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE /appointments/:id" do
    let!(:user) { create(:user) }
    let!(:customer) { create(:customer, user: user) }
    let!(:appointment) { create(:appointment, customer: customer, user: user, about: "Appointment to delete") }

    before { sign_in user }

    it "soft-deletes the appointment and returns 204" do
      delete "/appointments/#{appointment.id}",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:no_content)

      appointment.reload
      expect(appointment.deleted_at).not_to be_nil
    end

    context "when destroy fails" do
      it "returns 422 with errors" do
        allow_any_instance_of(Appointment).to receive(:destroy).and_return(false)
        allow_any_instance_of(Appointment).to receive_message_chain(:errors, :full_messages).and_return([ "Cannot delete appointment" ])

        delete "/appointments/#{appointment.id}",
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

        expect(response).to have_http_status(:unprocessable_content)

        json = JSON.parse(response.body)
        expect(json["errors"]).to be_an(Array)
      end
    end

    context "when appointment does not exist" do
      it "returns 404" do
        delete "/appointments/999999",
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
