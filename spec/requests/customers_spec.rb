require "rails_helper"

RSpec.describe "CustomersController", type: :request do
  describe "GET /customers" do
    let!(:user) { create(:user) }
    let!(:tag) { create(:tag, name: "VIP", tag_type: Tag::CUSTOMER_STATUS) }
    let!(:customer) { create(:customer, user: user) }
    let!(:other_customer) { create(:customer, user: user, name: "Other Co") }
    let!(:customer_tag) { create(:customer_tag, customer: customer, tag: tag) }

    before { sign_in user }

    it "returns all customers serialized with CustomerResource" do
      get "/customers",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      ids = json.map { |c| c["id"] }

      expect(ids).to include(customer.id, other_customer.id)
    end

    it "returns the correct attributes in the response" do
      get "/customers",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      customer_json = json.find { |c| c["id"] == customer.id }

      expect(customer_json["name"]).to eq(customer.name)
      expect(customer_json["about"]).to eq(customer.about)
      expect(customer_json["avatar_url"]).to be_nil
      expect(customer_json["tags"]).to be_an(Array)
      tag_names = customer_json["tags"].map { |t| t["name"] }
      expect(tag_names).to include("VIP")
    end

    context "when filtering by tag" do
      it "returns only customers with the matching tag" do
        get "/customers?tag=VIP",
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        ids = json.map { |c| c["id"] }

        expect(ids).to include(customer.id)
        expect(ids).not_to include(other_customer.id)
      end
    end

    context "when searching by name" do
      it "returns only customers matching the search term" do
        get "/customers?search=#{other_customer.name}",
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        ids = json.map { |c| c["id"] }

        expect(ids).to include(other_customer.id)
        expect(ids).not_to include(customer.id)
      end
    end
  end

  describe "GET /customers/:id" do
    let!(:user) { create(:user) }
    let!(:customer) { create(:customer, user: user) }

    before { sign_in user }

    it "returns the customer serialized with CustomerShowResource" do
      get "/customers/#{customer.id}",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json["id"]).to eq(customer.id)
      expect(json["name"]).to eq(customer.name)
      expect(json["email"]).to eq(customer.email)
      expect(json["phone"]).to eq(customer.phone)
      expect(json["address"]).to eq(customer.address)
      expect(json["about"]).to eq(customer.about)
      expect(json["user_id"]).to eq(customer.user_id)
      expect(json["user_name"]).to eq(user.name)
      expect(json["avatar_url"]).to be_nil
    end

    context "when customer does not exist" do
      it "returns 404" do
        get "/customers/999999",
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
