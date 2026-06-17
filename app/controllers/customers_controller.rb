class CustomersController < ApplicationController
  before_action :authenticate_user!
  def index
    render json: {
      message: "This is a secret message. You are seeing it because you have successfully logged in."
    }
  end
end
