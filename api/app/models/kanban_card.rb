class KanbanCard < ApplicationRecord
  belongs_to :kanban_column
  has_and_belongs_to_many :tags
end
