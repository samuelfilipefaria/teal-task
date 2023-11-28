class KanbanCard < ApplicationRecord
    belongs_to :kanban_column
    has_many :tags

    def initialize(title, description, delivery_date, kanban_column, tags)
        @title = title
        @description = description
        @delivery_date = delivery_date
        @kanban_column = kanban_column
        @tags = tags
    end

    attr_accessor :title, :description, :delivery_date, :kanban_column, :tags
end
