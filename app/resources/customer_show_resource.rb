class CustomerShowResource < BaseResource
  attributes :id, :name, :email, :phone, :address, :about

  attribute :user_name do |customer|
    customer.user&.name
  end
end
