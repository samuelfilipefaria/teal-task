class Tag < ApplicationRecord
    belongs_to :user
    has_many :kanban_cards
end
