class ClientResource < BaseResource
  include Rails.application.routes.url_helpers
  attributes :id, :name, :about

  attribute :avatar_url do |client|
    if client.avatar.attached?
      rails_blob_url(client.avatar, only_path: false)
    else
      nil
    end
  end
end
