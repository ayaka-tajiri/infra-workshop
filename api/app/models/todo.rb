class Todo < ApplicationRecord
  has_many :todo_list, dependent: :destroy
end
