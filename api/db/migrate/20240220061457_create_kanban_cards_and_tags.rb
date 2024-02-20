class CreateKanbanCardsAndTags < ActiveRecord::Migration[7.1]
  def change
    create_table :kanban_cards_tags, id: false do |t|
      t.belongs_to :kanban_card
      t.belongs_to :tag
    end
  end
end
