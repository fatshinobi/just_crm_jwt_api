class AppointmentElementResource < BaseResource
  attributes :id, :when, :about, :communication_type, :customer_id, :client_id, :user_id, :status, :opportunity_id

  attribute :customer_name do |appointment|
    appointment.customer&.name
  end

  attribute :client_name do |appointment|
    appointment.client&.name
  end

  attribute :user_name do |appointment|
    appointment.user&.name
  end

  attribute :opportunity_name do |appointment|
    appointment.opportunity&.title
  end

  attribute :formatted_when do |appointment|
    format_datetime(appointment.when)
  end
end
