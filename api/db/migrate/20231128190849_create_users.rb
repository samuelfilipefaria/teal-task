class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.integer :id
      t.string :name
      t.string :email
      t.string :password
      t.string :photo

      t.timestamps
    end
  end
end
