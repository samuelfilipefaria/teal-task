class Kanban < ApplicationRecord
    belongs_to :user
    has_many :kanban_columns, dependent: :destroy
end
