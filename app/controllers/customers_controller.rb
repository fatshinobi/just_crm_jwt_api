class CustomersController < ApplicationController
  before_action :authenticate_user!

  def index
    customers = CustomerResource.new(Customer.all)
    render json: customers.to_json, status: :ok
  end
end
