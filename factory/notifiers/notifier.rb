
class Notifier
  def send(message:)
    raise NotImplementedError, 'Subclasses must implement the send method'
  end
end