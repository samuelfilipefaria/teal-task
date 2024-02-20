class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password

      t.timestamps
    end

    change_table :tags do |t|
      t.belongs_to :user, foreign_key: true
    end

    change_table :kanban_columns do |t|
      t.belongs_to :user, foreign_key: true
    end
  end
end
