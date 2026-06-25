class CatalogsController < ApplicationController
  def users
    users = list_options_xy(User.pluck(:name, :id))
    render json: users.to_json, status: :ok
  end

  def clients_by_customer
    customer_id = params[:customer_id]
    existed_clients_ids = ClientCustomer.where(customer_id: customer_id).pluck(:client_id)
    clients = list_options_xy(Client.where.not(id: existed_clients_ids).pluck(:name, :id))
    render json: clients.to_json, status: :ok
  end

  private

  def list_options_xy(array)
    array.map { |x, y| { key: y, value: x } }
  end
end
