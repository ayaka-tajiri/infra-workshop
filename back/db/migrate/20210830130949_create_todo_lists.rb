class CreateTodoLists < ActiveRecord::Migration[6.0]
  def change
    create_table :todo_lists do |t|
      t.references :todo, foreign_key: true
      t.string :content
      t.boolean :complete, default: false

      t.timestamps
    end
  end
end
