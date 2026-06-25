class Customers::ClientsController < ApplicationController
  def index
    customer_id = params[:customer_id]
    records = ClientCustomer.includes(:client).where(customer_id: customer_id)
    clients = ClientCustomerElementResource.new(records)

    render json: clients.to_json, status: :ok
  end
end
