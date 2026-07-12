class Clients::TagsController < ApplicationController
  def index
    client_id = params[:id]
    tags_info = ClientTag.includes(:tag).where(client_id: client_id).pluck(:name)

    render json: tags_info.to_json, status: :ok
  end

  def create
    client_id = params[:id]
    tags_list = params[:tags]
    tags = tags_list.split(",")
    saved_tags_ids = []
    tags.each do |tag|
      clear_tag = tag.strip
      next if clear_tag.blank?
      saved_tag = Tag.find_or_create_by(name: clear_tag, tag_type: Tag::CLIENT_STATUS)

      ClientTag.find_or_create_by(tag_id: saved_tag.id, client_id: client_id)
      saved_tags_ids << saved_tag.id
    end
    ClientTag.where(client_id: client_id).where.not(tag_id: saved_tags_ids).delete_all

    render json: "Created".to_json, status: :created
  end
end
