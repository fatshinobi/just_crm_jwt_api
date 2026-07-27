class Clients::AppointmentsController < ApplicationController
  def index
    client_id = params[:id]
    appointments_records = Appointment.includes(:customer, :client, :user).where(client_id: client_id).order(when: :desc)
    appointments = AppointmentElementResource.new(appointments_records)
    render json: appointments, status: :ok
  end
end
