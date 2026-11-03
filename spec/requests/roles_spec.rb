require "rails_helper"

RSpec.describe "RolesController", type: :request do
  describe "GET /roles/:start_str" do
    let!(:user) { create(:user, email: "roles_index@example.com") }
    let!(:role1) { create(:role, name: "Manager") }
    let!(:role2) { create(:role, name: "Admin") }
    let!(:role3) { create(:role, name: "Supervisor") }

    before { sign_in user }

    it "returns role names starting with the given prefix" do
      get "/roles/Ma",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json).to include("Manager")
      expect(json).not_to include("Admin", "Supervisor")
    end

    it "limits results to 5" do
      6.times { |i| create(:role, name: "Role#{i}") }

      get "/roles/R",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json.size).to eq(5)
    end

    it "is case-insensitive" do
      get "/roles/ma",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json).to include("Manager")
    end
  end
end
