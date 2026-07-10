class Customers::TagsController < ApplicationController
  def index
    customer_id = params[:id]
    tags_info = CustomerTag.includes(:tag).where(customer_id: customer_id).pluck(:name)

    render json: tags_info.to_json, status: :ok
  end

  def create
    customer_id = params[:id]
    tags_list = params[:tags]
    tags = tags_list.split(",")
    saved_tags_ids = []
    tags.each do |tag|
      clear_tag = tag.strip
      next if clear_tag.blank?
      saved_tag = Tag.find_or_create_by(name: clear_tag, tag_type: Tag::CUSTOMER_STATUS)

      CustomerTag.find_or_create_by(tag_id: saved_tag.id, customer_id: customer_id)
      saved_tags_ids << saved_tag.id
    end
    CustomerTag.where(customer_id: customer_id).where.not(tag_id: saved_tags_ids).delete_all

    render json: "Created".to_json, status: :created
  end
end
