require_relative 'todo'

class TodoList
  attr_accessor :title

  def initialize(title)
    @title = title
    @todos = []
  end

  def size
    @todos.size
  end

  def first
    @todos.first
  end

  def last
    @todos.last
  end

  def shift
    @todos.shift
  end

  def pop
    @todos.pop
  end

  def add(todo)
    raise TypeError, 'Can only add Todo objects' if todo.class != Todo
    @todos << todo
  end

  alias_method :<<, :add

  def item_at(index)
    @todos.fetch(index)
  end

  def remove_at(index)
    @todos.delete(item_at(index))
  end

  def mark_done_at(index)
    item_at(index).done!
  end

  def mark_undone_at(index)
    item_at(index).undone!
  end

  def done?
    @todos.all? { |todo| todo.done? }
  end

  def done!
    @todos.each { |todo| todo.done! }
  end

  def mark_all_done
    self.each { |todo| todo.done! }
  end

  def mark_all_undone
    self.each { |todo| todo.undone! }
  end

  def find_by_title(todo_title)
    self.select { |todo| todo.title == todo_title }.first
  end

  def mark_done(todo_title)
    self.find_by_title(todo_title) && self.find_by_title(todo_title).done!
  end

  def all_done
    self.select { |todo| todo.done? }
  end

  def all_not_done
    self.select { |todo| !todo.done? }
  end

  def to_s
    "---- #{title} ----\n" + @todos.join("\n")
  end

  def to_a
    @todos
  end

  def each
    @todos.each { |todo| yield(todo) }
    self
  end

  def select
    selected_items = TodoList.new('Selected items')
    self.each { |todo| selected_items << todo if yield(todo) }
    selected_items
  end
end
