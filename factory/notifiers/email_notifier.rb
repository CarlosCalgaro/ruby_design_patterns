require_relative 'notifier'

class EmailNotifier < Notifier
  def send(message:)
    puts "Sending EMAIL: #{message}"
  end
end