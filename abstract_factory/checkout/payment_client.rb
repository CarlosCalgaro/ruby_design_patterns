class PaymentClient
  def charge(amount_cents:, currency:, customer_id:)
    raise NotImplementedError, 'Subclasses must implement the charge method'
  end

  def refund(payment_id:)
    raise NotImplementedError, 'Subclasses must implement the refund method'
  end
end