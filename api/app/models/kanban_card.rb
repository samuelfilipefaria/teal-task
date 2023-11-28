class KanbanCard < ApplicationRecord
    belongs_to :kanban_column
    has_many :tags
end
