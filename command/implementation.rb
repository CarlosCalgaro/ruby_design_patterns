class TextEditor
  attr_accessor :text

  def initialize(text = "")
    @text = text
  end
end


class Command
  attr_reader :editor

  def initialize(editor)
    @editor = editor
  end

  def execute
    raise NotImplementedError, "Subclasses must implement the execute method"
  end

  def undo
    raise NotImplementedError, "Subclasses must implement the undo method"
  end

end


class InsertCommand < Command
  attr_reader :text, :position

  def initialize(editor, position, text)
    super(editor)
    @text = text
    @position = position
  end

  def execute
    editor.text = editor.text.dup.insert(position, text)
  end

  def undo
    new_str = editor.text.dup
    new_str.slice!(position, text.length)
    editor.text = new_str
  end
end


class DeleteCommand < Command
  attr_reader :position, :length
  def initialize(editor, position, length)
    super(editor)
    @position = position
    @length = length
    @deleted_text = nil
  end

  def execute 
    new_str = editor.text.dup
    @deleted_text = new_str.slice(position, length)
    new_str.slice!(position, length)
    editor.text = new_str
  end

  def undo
    return unless @deleted_text
    new_str = editor.text.dup
    new_str.insert(position, @deleted_text)
    editor.text = new_str
  end
end

class CommandHistory
  def initialize
    @undo_stack = []
    @redo_stack = []
  end

  def execute(command)
    command.execute()
    @undo_stack << command
    @redo_stack.clear
  end 
end

class ReplaceCommand < Command
  attr_reader :position, :length, :new_text

  def initialize(editor, position, length, new_text)
    super(editor)
    @position = position
    @length = length
    @new_text = new_text
    @old_text = nil
  end

  def execute
    new_str = editor.text.dup
    @old_text = new_str.slice(position, length)
    new_str.slice!(position, length)
    new_str.insert(position, new_text)
    editor.text = new_str
  end

  def undo
    return unless @old_text
    new_str = editor.text.dup
    new_str.slice!(position, new_text.length)
    new_str.insert(position, @old_text)
    editor.text = new_str
  end
end

class CommandHistory
  def initialize
    @undo_stack = []
    @redo_stack = []
  end

  def execute(command)
    command.execute
    @undo_stack << command
    @redo_stack.clear
  end

  def undo
    return if @undo_stack.empty?
    cmd = @undo_stack.pop
    cmd.undo
    @redo_stack << cmd
  end

  def redo
    return if @redo_stack.empty?
    cmd = @redo_stack.pop
    cmd.execute
    @undo_stack << cmd
  end
end

editor = TextEditor.new("Hello World")
history = CommandHistory.new

# Execute commands
cmd1 = InsertCommand.new(editor, 5, ", Beautiful")
history.execute(cmd1)
puts editor.text  # => "Hello, Beautiful World"


cmd2 = DeleteCommand.new(editor, 7, 10)  # Delete "Beautiful "
history.execute(cmd2)
puts editor.text  # => "Hello, World"

cmd3 = ReplaceCommand.new(editor, 0, 5, "Goodbye")
history.execute(cmd3)
puts editor.text  # => "Goodbye, World"

# Undo operations
history.undo
puts editor.text  # => "Hello, World"

history.undo
puts editor.text  # => "Hello, Beautiful World"

# Redo operations
history.redo
puts editor.text  # => "Hello, World"