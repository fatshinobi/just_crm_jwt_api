class ClientShowResource < BaseResource
  include Rails.application.routes.url_helpers
  attributes :id, :name, :about, :email, :phone, :social, :user_id

  attribute :user_name do |client|
    client.user&.name
  end

  attribute :avatar_url do |client|
    if client.avatar.attached?
      rails_blob_url(client.avatar, only_path: false)
    else
      nil
    end
  end
end
