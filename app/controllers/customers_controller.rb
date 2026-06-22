class CustomersController < ApplicationController
  before_action :set_customer, only: [ :show, :update ]

  def index
    customers = CustomerResource.new(Customer.all)
    render json: customers.to_json, status: :ok
  end

  def show
    render json: CustomerShowResource.new(@customer), status: :ok
  end

  def update
    if @customer.update(customer_params)
      render json: CustomerShowResource.new(@customer), status: :ok
    else
      render json: { errors: customer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create
    customer = Customer.new(customer_params)
    if customer.save
      render json: CustomerShowResource.new(customer), status: :created
    else
      render json: { errors: customer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def customer_params
    params.permit(:name, :email, :phone, :address, :about, :user_id, :avatar)
  end

  def set_customer
    @customer = Customer.find(params[:id])
  end
end
