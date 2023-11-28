class CreateKanbans < ActiveRecord::Migration[7.1]
  def change
    create_table :kanbans do |t|

      t.timestamps
    end
  end
end
