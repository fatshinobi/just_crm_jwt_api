class Clients::OpportunitiesController < ApplicationController
  def index
    client_id = params[:id]

    opportunities_records = Opportunity.includes(:customer, :client, :user).where(client_id: client_id).order(start: :desc)
    opportunities = OpportunityElementResource.new(opportunities_records)
    render json: opportunities, status: :ok
  end
end
