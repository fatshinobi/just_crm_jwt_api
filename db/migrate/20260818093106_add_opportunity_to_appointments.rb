class AddOpportunityToAppointments < ActiveRecord::Migration[8.1]
  def change
    add_reference :appointments, :opportunity, foreign_key: true
  end
end
