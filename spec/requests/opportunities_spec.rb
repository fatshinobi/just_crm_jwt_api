require "rails_helper"

RSpec.describe "OpportunitiesController", type: :request do
  describe "GET /opportunities" do
    let!(:user) { create(:user) }
    let!(:customer) { create(:customer, user: user) }
    let!(:tag) { create(:tag, name: "Hot", tag_type: Tag::OPPORTUNITY_STATUS) }
    let!(:opportunity) { create(:opportunity, customer: customer, user: user, title: "Big Deal") }
    let!(:other_opportunity) { create(:opportunity, customer: customer, user: user, title: "Small Deal") }
    let!(:opportunity_tag) { create(:opportunity_tag, opportunity: opportunity, tag: tag) }

    before { sign_in user }

    it "returns all opportunities serialized with OpportunityElementResource" do
      get "/opportunities",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      ids = json.map { |o| o["id"] }

      expect(ids).to include(opportunity.id, other_opportunity.id)
    end

    it "returns the correct attributes in the response" do
      get "/opportunities",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      opp_json = json.find { |o| o["id"] == opportunity.id }

      expect(opp_json["id"]).to eq(opportunity.id)
      expect(opp_json["title"]).to eq("Big Deal")
      expect(opp_json["description"]).to eq(opportunity.description)
      expect(opp_json["amount"]).to eq(opportunity.amount.to_s)
      expect(opp_json["stage"]).to eq(opportunity.stage)
      expect(opp_json["status"]).to eq(opportunity.status)
      expect(opp_json["customer_id"]).to eq(customer.id)
      expect(opp_json["user_id"]).to eq(user.id)
      expect(opp_json["user_name"]).to eq(user.name)
      expect(opp_json["customer_name"]).to eq(customer.name)
    end

    it "includes tags in the response" do
      get "/opportunities",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      opp_json = json.find { |o| o["id"] == opportunity.id }

      expect(opp_json["tags"]).to be_an(Array)
      expect(opp_json["tags"].length).to eq(1)
      expect(opp_json["tags"].first["name"]).to eq("Hot")
    end

    context "when filtering by tag" do
      it "returns only opportunities with the matching tag" do
        get "/opportunities?tag=Hot",
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        ids = json.map { |o| o["id"] }

        expect(ids).to include(opportunity.id)
        expect(ids).not_to include(other_opportunity.id)
      end
    end

    context "when searching by title" do
      it "returns only opportunities matching the search term" do
        get "/opportunities?search=Small",
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        ids = json.map { |o| o["id"] }

        expect(ids).to include(other_opportunity.id)
        expect(ids).not_to include(opportunity.id)
      end
    end

    context "when filtering by stage" do
      let!(:staged_opportunity) { create(:opportunity, customer: customer, user: user, title: "Staged Deal", stage: 2) }

      it "returns only opportunities with the matching stage" do
        get "/opportunities?stage=2",
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        ids = json.map { |o| o["id"] }

        expect(ids).to include(staged_opportunity.id)
        expect(ids).not_to include(opportunity.id)
        expect(ids).not_to include(other_opportunity.id)
      end
    end
  end

  describe "GET /opportunities/:id" do
    let!(:user) { create(:user) }
    let!(:customer) { create(:customer, user: user) }
    let!(:opportunity) { create(:opportunity, customer: customer, user: user) }

    before { sign_in user }

    it "returns the opportunity serialized with OpportunityElementResource" do
      get "/opportunities/#{opportunity.id}",
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json["id"]).to eq(opportunity.id)
      expect(json["title"]).to eq(opportunity.title)
      expect(json["description"]).to eq(opportunity.description)
      expect(json["amount"]).to eq(opportunity.amount.to_s)
      expect(json["stage"]).to eq(opportunity.stage)
      expect(json["status"]).to eq(opportunity.status)
      expect(json["customer_id"]).to eq(customer.id)
      expect(json["user_id"]).to eq(user.id)
      expect(json["user_name"]).to eq(user.name)
      expect(json["customer_name"]).to eq(customer.name)
    end

    context "when opportunity does not exist" do
      it "returns 404" do
        get "/opportunities/999999",
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /opportunities" do
    let!(:user) { create(:user) }
    let!(:customer) { create(:customer, user: user) }

    before { sign_in user }

    it "creates an opportunity and returns the serialized response with OpportunityElementResource" do
      post "/opportunities",
        params: {
          title: "New Opportunity",
          description: "A new opportunity",
          amount: 7500.00,
          stage: 0,
          status: 0,
          start: "2024-01-01",
          finish: "2024-12-31",
          customer_id: customer.id,
          user_id: user.id
        }.to_json,
        headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

      expect(response).to have_http_status(:created)

      json = JSON.parse(response.body)

      expect(json["title"]).to eq("New Opportunity")
      expect(json["description"]).to eq("A new opportunity")
      expect(json["amount"]).to eq("7500.0")
      expect(json["stage"]).to eq(0)
      expect(json["status"]).to eq(0)
      expect(json["customer_id"]).to eq(customer.id)
      expect(json["user_id"]).to eq(user.id)
      expect(json["user_name"]).to eq(user.name)
      expect(json["customer_name"]).to eq(customer.name)
    end

    context "when required params are missing" do
      it "returns 422 with errors" do
        allow_any_instance_of(Opportunity).to receive(:save).and_return(false)
        allow_any_instance_of(Opportunity).to receive_message_chain(:errors, :full_messages).and_return([ "Customer must exist" ])

        post "/opportunities",
          params: { title: "New Opportunity" }.to_json,
          headers: { "Accept" => "application/json", "Content-Type" => "application/json" }

        expect(response).to have_http_status(:unprocessable_entity)

        json = JSON.parse(response.body)
        expect(json["errors"]).to be_an(Array)
      end
    end
  end
end
