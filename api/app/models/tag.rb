class Tag < ApplicationRecord
    belongs_to :user
    has_many :kanban_cards

    def initialize(text, color, user)
        @text = text
        @color = color
        @user = user
    end

    attr_accessor :text, :color, :user
end
