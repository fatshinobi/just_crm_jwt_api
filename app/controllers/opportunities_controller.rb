class OpportunitiesController < ApplicationController
  before_action :set_opportunity, only: [ :show, :update ]

  def index
    tag_val = params[:tag]
    opportunities = Opportunity.all

    if tag_val.present?
      tag_id = Tag.find_by(name: tag_val, tag_type: Tag::OPPORTUNITY_STATUS)&.id
      opportunities = opportunities.joins(:opportunity_tags).where(opportunity_tags: { tag_id: tag_id }) if tag_id
    end

    opportunities = opportunities.includes(:opportunity_tags, :tags)

    records = OpportunityElementResource.new(opportunities)
    render json: records, status: :ok
  end

  def show
    record = OpportunityElementResource.new(@opportunity)
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

  def update
    if @opportunity.update(opportunity_params)
      render json: OpportunityElementResource.new(@opportunity), status: :ok
    else
      render json: { errors: @opportunity.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_opportunity
    @opportunity = Opportunity.find(params[:id])
  end

  def opportunity_params
    params.permit(:title, :description, :stage, :status, :start, :finish, :customer_id, :user_id, :client_id, :amount)
  end
end
