
class WebhookVerifier
  def verify(signature:, payload:)
    raise NotImplementedError, 'Subclasses must implement the verify method'
  end
end