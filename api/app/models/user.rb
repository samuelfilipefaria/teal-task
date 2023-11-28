class User < ApplicationRecord
    has_many :tags, dependent: :destroy
    has_one :kanban, dependent: :destroy
end
