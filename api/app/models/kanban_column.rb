class KanbanColumn < ApplicationRecord
  has_many :kanban_cards, dependent: :destroy
end
