class ReceiptFormatter
  def format(payment_id:, amount_cents:, currency:)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end