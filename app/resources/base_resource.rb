# frozen_string_literal: true

class BaseResource
  include Alba::Resource

  def format_date(value)
    return unless value
    return "" unless value.respond_to?(:strftime)

    value.strftime("%F")
  end

  def format_datetime(value)
    return "" unless value.respond_to?(:strftime)

    value.strftime("%F %T")
  end

  def format_checkbox(value)
    [ "true", "1", "t" ].include?(value) || false
  end
end
