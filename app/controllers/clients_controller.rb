class ClientsController < ApplicationController
  def index
    clients = ClientResource.new(Client.all)
    render json: clients.to_json, status: :ok
  end

  def create
    client = Client.new(client_params)
    if client.save
      render json: ClientResource.new(client), status: :created
    else
      render json: { errors: client.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def client_params
    params.permit(:name, :about, :user_id, :avatar, :email, :phone, :social)
  end
end
