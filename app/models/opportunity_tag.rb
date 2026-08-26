class OpportunityTag < ApplicationRecord
  belongs_to :opportunity
  belongs_to :tag
end
