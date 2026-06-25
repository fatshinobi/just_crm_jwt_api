class ClientCustomerResource < BaseResource
  attributes :id, :client_id, :customer_id, :role

  attribute :client_name do |client_customer|
    client_customer.client&.name
  end

  attribute :customer_name do |client_customer|
    client_customer.customer&.name
  end
end
