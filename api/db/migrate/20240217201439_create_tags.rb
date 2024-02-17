class CreateTags < ActiveRecord::Migration[7.1]
  def change
    create_table :tags do |t|
      t.string :label
      t.string :color

      t.timestamps
    end
  end
end
