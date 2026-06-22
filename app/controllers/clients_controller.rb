class ClientsController < ApplicationController
  def index
    clients = ClientResource.new(Client.all)
    render json: clients.to_json, status: :ok
  end
end
