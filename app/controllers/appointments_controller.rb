class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [ :show, :update ]

  def create
    appointment = Appointment.new(appointment_params)

    if appointment.save
      render json: AppointmentResource.new(appointment), status: :created
    else
      render json: { errors: appointment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: AppointmentElementResource.new(@appointment), status: :ok
  end

  def update
    if @appointment.update(appointment_params)
      render json: AppointmentResource.new(@appointment), status: :ok
    else
      render json: { errors: @appointment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_appointment
    @appointment = Appointment.find(params[:id])
  end

  def appointment_params
    params.permit(:when, :about, :user_id, :customer_id, :client_id, :communication_type, :status)
  end
end
