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

  def create
    opportunity = Opportunity.new(opportunity_params)

    if opportunity.save
      render json: OpportunityElementResource.new(opportunity), status: :created
    else
      render json: { errors: opportunity.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def opportunity_params
    params.permit(:title, :description, :stage, :status, :start, :finish, :customer_id, :user_id, :client_id, :amount)
  end
end
