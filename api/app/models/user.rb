class User < ApplicationRecord
  has_many :tags, dependent: :destroy
  has_many :kanban_columns, dependent: :destroy
end
