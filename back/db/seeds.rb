# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
todo_1 = Todo.create!({ title: '今日やるTODO' })

todo_2 = Todo.create!({ title: '買うものリスト' })

TodoList.create!(
  [
    {
      todo_id: todo_1.id,
      content: '朝ごはんを作る'
    },
    {
      todo_id: todo_1.id,
      content: '昼ごはんを作る'
    },
    {
      todo_id: todo_2.id,
      content: '卵',
      complete: false
    }
  ]
)
