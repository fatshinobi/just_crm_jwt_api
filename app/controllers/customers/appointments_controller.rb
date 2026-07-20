class Customers::AppointmentsController < ApplicationController
  def index
    customer_id = params[:id]
    appointments_records = Appointment.includes(:customer).where(customer_id: customer_id).order(when: :desc)
    appointments = AppointmentResource.new(appointments_records)
    render json: appointments, status: :ok
  end
end
