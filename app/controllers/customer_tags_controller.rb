class CustomerTagsController < ApplicationController
  def index
    tags_info = CustomerTag.includes(:tag).group(:tag_id)

    render json: tags_info.pluck("tags.name, count(tag_id)").to_json, status: :ok
  end
end
