require_relative 'notifier'

class SmsNotifier < Notifier
  def send(message:)
    puts "Sending SMS: #{message}"
  end
end