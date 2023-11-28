class KanbanColumn < ApplicationRecord
    belongs_to :kanban
    has_many :kanban_cards, dependent: :destroy

    def initialize(name, color, kanban)
        @name = name
        @color = color
        @kanban = kanban
    end

    attr_accessor :name, :color, :kanban
end
