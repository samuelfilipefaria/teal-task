class KanbanColumn < ApplicationRecord
    belongs_to :kanban
    has_many :kanban_cards, dependent: :destroy
end
