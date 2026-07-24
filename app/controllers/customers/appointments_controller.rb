class Customers::AppointmentsController < ApplicationController
  def index
    customer_id = params[:id]
    appointments_records = Appointment.includes(:customer, :client, :user).where(customer_id: customer_id).order(when: :desc)
    appointments = AppointmentElementResource.new(appointments_records)
    render json: appointments, status: :ok
  end
end
