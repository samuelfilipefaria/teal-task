class User < ApplicationRecord
    has_many :tags, dependent: :destroy
    has_one :kanban, dependent: :destroy

    def initialize(name, email, password, photo)
        @name = name
        @email = email
        @password = password
        @photo = photo
    end

    attr_accessor :name, :email, :password, :photo
end
