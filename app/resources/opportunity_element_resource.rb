class OpportunityElementResource < BaseResource
  include Rails.application.routes.url_helpers
  attributes :id, :title, :description, :amount, :stage, :status, :start, :finish, :customer_id, :client_id, :user_id

  attribute :user_name do |record|
    record.user&.name
  end

  attribute :customer_name do |record|
    record.customer&.name
  end

  attribute :client_name do |record|
    record.client&.name
  end
end
