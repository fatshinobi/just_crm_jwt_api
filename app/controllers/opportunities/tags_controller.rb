class Opportunities::TagsController < ApplicationController
  def index
    opportunity_id = params[:id]
    tags_info = OpportunityTag.includes(:tag).where(opportunity_id: opportunity_id).pluck(:name)

    render json: tags_info.to_json, status: :ok
  end
end
