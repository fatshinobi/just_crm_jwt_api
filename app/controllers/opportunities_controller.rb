class OpportunitiesController < ApplicationController
  def index
    opportunities = Opportunity.all

    records = OpportunityElementResource.new(opportunities)
    render json: records, status: :ok
  end

  def show
    opportunity = Opportunity.find(params[:id])

    record = OpportunityElementResource.new(opportunity)
    render json: record, status: :ok
  end
end
