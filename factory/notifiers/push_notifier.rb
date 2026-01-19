require_relative 'notifier'

class PushNotifier < Notifier
  def send(message:)
    puts "Sending PUSH: #{message}"
  end
end