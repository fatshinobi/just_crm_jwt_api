class CustomerShowResource < BaseResource
  attributes :id, :name, :email, :phone, :address, :about, :user_id

  attribute :user_name do |customer|
    customer.user&.name
  end
end
