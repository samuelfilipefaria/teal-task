class Kanban < ApplicationRecord
    belongs_to :user
    has_many :kanban_columns, dependent: :destroy

    def initialize(user)
        @user = user
    end

    attr_accessor :user
end
