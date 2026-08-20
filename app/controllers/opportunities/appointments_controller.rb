class Opportunities::AppointmentsController < ApplicationController
  def index
    opportunity_id = params[:opportunity_id]
    appointments_records = Appointment.includes(:customer, :client, :opportunity, :user).where(opportunity_id: opportunity_id).order(when: :desc)
    appointments = AppointmentElementResource.new(appointments_records)
    render json: appointments, status: :ok
  end
end
