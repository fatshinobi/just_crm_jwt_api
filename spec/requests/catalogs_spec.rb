require "rails_helper"

RSpec.describe "CatalogsController", type: :request do
  describe "GET /catalogs/users" do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user, name: "Admin User", email: "admin@example.com") }

    before { sign_in user }

    it "returns all users as key-value pairs" do
      get "/catalogs/users",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json).to be_an(Array)
      expect(json.length).to eq(2)

      keys = json.map { |u| u["key"] }
      expect(keys).to include(user.id, other_user.id)

      values = json.map { |u| u["value"] }
      expect(values).to include(user.name, "Admin User")
    end
  end
end
