# Command Pattern

## Pattern Explanation

The Command pattern is a behavioral design pattern that turns a request into a stand-alone object that contains all information about the request. This transformation allows you to parameterize methods with different requests, queue requests, log requests, and support undoable operations.

Key components:
- **Command**: Interface with execute() method
- **Concrete Command**: Implements execute() and binds receiver with action
- **Receiver**: Performs the actual work
- **Invoker**: Asks command to execute the request
- **Client**: Creates commands and associates them with receivers

## Challenge: Text Editor with Undo/Redo

You're building a text editor that supports complex operations with full undo/redo functionality. Implement the Command pattern to encapsulate editing operations and maintain command history.

### Requirements

1. Create a text editor that supports operations:
   - **Insert**: Add text at a position
   - **Delete**: Remove text from a position
   - **Replace**: Replace text in a range
   - **Format**: Apply formatting (bold, italic, uppercase)
2. Each command should:
   - Be executable
   - Be undoable
   - Store enough information to reverse itself
   - Track execution timestamp
3. The editor should:
   - Maintain command history
   - Support undo (reverse last command)
   - Support redo (re-apply undone command)
   - Support undo/redo multiple steps
   - Allow macro recording (combine multiple commands)

### Example Usage

```ruby
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

# Macro - combine multiple commands
macro = MacroCommand.new([
  DeleteCommand.new(editor, 5, 6),      # Delete comma
  InsertCommand.new(editor, 5, "!"),    # Add exclamation
  FormatCommand.new(editor, 0, 5, :uppercase)  # Uppercase "Hello"
])

history.execute(macro)
puts editor.text  # => "HELLO! World"

history.undo  # Undoes all macro commands at once
puts editor.text  # => "Hello, World"
```

### Bonus Points

- Implement command serialization to save/load editing history
- Add memory limits to command history (drop old commands)
- Create a command scheduler for delayed execution
- Implement transactional commands (all-or-nothing execution)
