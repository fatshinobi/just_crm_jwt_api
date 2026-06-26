class ClientCustomersController < ApplicationController
  before_action :set_client, only: [ :show, :update ]
  def create
    client_customer = ClientCustomer.new(client_customer_params)
    if client_customer.save
      render json: ClientCustomerResource.new(client_customer), status: :created
    else
      render json: { errors: client.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @client_customer = ClientCustomer.find(params[:id])
    if @client_customer.update(client_customer_params)
      render json: ClientCustomerResource.new(@client_customer), status: :ok
    else
      render json: { errors: client.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: ClientCustomerResource.new(@client_customer), status: :ok
  end

  private
  def set_client
    @client_customer = ClientCustomer.find(params[:id])
  end

  def client_customer_params
    params.permit(:role, :client_id, :customer_id)
  end
end
