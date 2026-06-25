class ClientCustomersController < ApplicationController
  def create
    client_customer = ClientCustomer.new(client_customer_params)
    if client_customer.save
      render json: ClientCustomerResource.new(client_customer), status: :created
    else
      render json: { errors: client.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def client_customer_params
    params.permit(:role, :client_id, :customer_id)
  end
end
