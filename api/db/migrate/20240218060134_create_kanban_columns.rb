class CreateKanbanColumns < ActiveRecord::Migration[7.1]
  def change
    create_table :kanban_columns do |t|
      t.string :title
      t.string :color
      t.integer :position

      t.timestamps
    end
  end
end
