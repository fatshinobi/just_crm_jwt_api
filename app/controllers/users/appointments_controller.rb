class Users::AppointmentsController < ApplicationController
  def index
    user_id = params[:id]
    appointments_records = Appointment.includes(:customer, :client, :user).where(user_id: user_id).order(when: :desc)
    appointments = AppointmentElementResource.new(appointments_records)
    render json: appointments, status: :ok
  end
end
