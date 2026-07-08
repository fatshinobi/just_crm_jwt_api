class RolesController < ApplicationController
  def index
    start_str = params[:start_str]
    roles = Role.all
    roles = roles.where("LOWER(name) LIKE ?", "#{start_str.downcase}%") if start_str

    render json: roles.limit(5).pluck(:name).to_json, status: :ok
  end
end
