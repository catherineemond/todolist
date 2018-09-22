require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!
require_relative '../lib/todolist'

class TodoListTest < Minitest::Test
  def setup
    @todo1 = Todo.new('Buy milk')
    @todo2 = Todo.new('Clean room')
    @todo3 = Todo.new('Go to gym')
    @todos = [@todo1, @todo2, @todo3]

    @list = TodoList.new("Today's Todos")
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
  end

  def test_to_a
    assert_equal(@todos, @list.to_a)
  end

  def test_size
    assert_equal(3, @list.size)
  end

  def test_first
    assert_equal(@todo1, @list.first)
  end

  def test_last
    assert_equal(@todo3, @list.last)
  end

  def test_shift
    assert_equal(@todo1, @list.shift)
    assert_equal([@todo2, @todo3], @list.to_a)
  end

  def test_pop
    assert_equal(@todo3, @list.pop)
    assert_equal([@todo1, @todo2], @list.to_a)
  end

  def test_done_question
    assert_equal(false, @list.done?)
    @todos.each { |todo| todo.done! }
    assert_equal(true, @list.done?)
  end

  def test_add_type_error
    assert_raises(TypeError) { @list.add('hello') }
    assert_raises(TypeError) { @list.add(5) }
  end

  def test_shovel
    new_todo = Todo.new('Write email')
    @list << new_todo
    assert_equal(new_todo, @list.last)
  end

  def test_add
    new_todo = Todo.new('Call friend')
    @list.add(new_todo)
    assert_equal(new_todo, @list.last)
  end

  def test_item_at
    assert_equal(@todo1, @list.item_at(0))
    assert_equal(@todo2, @list.item_at(1))
    assert_raises(IndexError) { @list.item_at(10) }
  end

  def test_mark_done_at
    @list.mark_done_at(0)
    assert(@todo1.done?)
    assert_equal(false, @todo2.done?)
    assert_equal(false, @todo3.done?)
    assert_raises(IndexError) { @list.mark_done_at(10) }
  end

  def test_mark_undone_at
    @todos.each { |todo| todo.done! }
    @list.mark_undone_at(0)
    assert_equal(false, @todo1.done?)
    assert(@todo2.done?)
    assert(@todo3.done?)
    assert_raises(IndexError) { @list.mark_undone_at(10) }
  end

  def test_done_bang
    @list.done!
    assert(@todos.all?(&:done?))
  end

  def test_remove_at
    assert_raises(IndexError) { @list.remove_at(10) }
    assert_equal(@todo1, @list.remove_at(0))
    assert_equal(@todo2, @list.item_at(0))
    assert_equal(@todo3, @list.item_at(1))
    assert_equal(2, @list.size)
  end

  def test_to_s
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [ ] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT

    assert_equal(output, @list.to_s)
  end

  def test_to_s_one_done
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT

    @list.first.done!
    assert_equal(output, @list.to_s)
  end

  def test_to_s_all_done
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [X] Clean room
    [X] Go to gym
    OUTPUT

    @list.done!
    assert_equal(output, @list.to_s)
  end

  def test_each
    @list.each { |todo| todo.done! }
    assert(@todos.all?(&:done?))
  end

  def test_each_return_value
    return_value = @list.each { |todo| nil }
    assert_same(@list, return_value)
  end

  def test_select
    @todo1.done!
    selected = @list.select { |todo| todo.done? }
    assert_equal(@todo1, selected.first)
    assert_equal(1, selected.size)
    assert_instance_of(TodoList, selected)
  end

  def test_mark_all_done
    @list.mark_all_done
    assert(@todos.all?(&:done?))
  end

  def test_mark_all_undone
    @todos.each(&:done!)
    @list.mark_all_undone
    assert(@todos.none? { |todo| todo.done? })
  end

  def test_find_by_title
    todo = @list.find_by_title('Clean room')
    assert_equal(@todo2, todo)
  end

  def test_mark_done
    @list.mark_done('Clean room')
    assert(@todo2.done?)
  end

  def test_all_done
    @todo1.done!
    @todo3.done!
    selected = @list.all_done
    assert_equal([@todo1, @todo3], selected.to_a)
    assert_instance_of(TodoList, selected)
  end

  def test_all_not_done
    @todo1.done!
    selected = @list.all_not_done
    assert_equal([@todo2, @todo3], selected.to_a)
    assert_instance_of(TodoList, selected)
  end
end
