class Clients::CustomersController < ApplicationController
  def index
    client_id = params[:client_id]
    records = ClientCustomer.includes(:customer).where(client_id: client_id)
    customers = CustomerClientElementResource.new(records)

    render json: customers, status: :ok
  end
end
