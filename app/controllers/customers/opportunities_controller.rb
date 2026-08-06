class Customers::OpportunitiesController < ApplicationController
  def index
    customer_id = params[:id]
    opportunities_records = Opportunity.includes(:customer, :client, :user).where(customer_id: customer_id).order(start: :desc)
    opportunities = OpportunityElementResource.new(opportunities_records)
    render json: opportunities, status: :ok
  end
end
