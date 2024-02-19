class CreateKanbanCards < ActiveRecord::Migration[7.1]
  def change
    create_table :kanban_cards do |t|
      t.belongs_to :kanban_column, foreign_key: true
      t.string :title
      t.string :description
      t.integer :position
      t.date :due_date

      t.timestamps
    end
  end
end
