class CatalogsController < ApplicationController
  def users
    users = list_options_xy(User.pluck(:name, :id))
    render json: users.to_json, status: :ok
  end

  private

  def list_options_xy(array)
    array.map { |x, y| { key: y, value: x } }
  end
end
