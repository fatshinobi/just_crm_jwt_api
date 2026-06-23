class ClientsController < ApplicationController
  before_action :set_client, only: [ :show, :update ]
  def index
    clients = ClientResource.new(Client.all)
    render json: clients.to_json, status: :ok
  end

  def create
    client = Client.new(client_params)
    if client.save
      render json: ClientShowResource.new(client), status: :created
    else
      render json: { errors: client.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: ClientShowResource.new(@client).to_json, status: :ok
  end

  def update
    if @client.update(client_params)
      render json: ClientShowResource.new(@client).to_json, status: :ok
    else
      render json: { errors: @client.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_client
    @client = Client.find(params[:id])
  end

  def client_params
    params.permit(:name, :about, :user_id, :avatar, :email, :phone, :social)
  end
end
