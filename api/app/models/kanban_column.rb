class KanbanColumn < ApplicationRecord
  has_many :kanban_cards, dependent: :destroy
  belongs_to :user
end
