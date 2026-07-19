class AppointmentsController < ApplicationController
  def create
    appointment = Appointment.new(appointment_params)

    if appointment.save
      render json: AppointmentResource.new(appointment), status: :created
    else
      render json: { errors: appointment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_client
    @appointment = Appointment.find(params[:id])
  end

  def appointment_params
    params.permit(:when, :about, :user_id, :customer_id, :client_id, :communication_type, :status)
  end
end
