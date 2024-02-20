class Tag < ApplicationRecord
  has_and_belongs_to_many :kanban_cards
end
