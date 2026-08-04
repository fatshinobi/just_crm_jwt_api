class OpportunitiesController < ApplicationController
  def index
    opportunities = Opportunity.all

    records = OpportunityElementResource.new(opportunities)
    render json: records, status: :ok
  end
end
