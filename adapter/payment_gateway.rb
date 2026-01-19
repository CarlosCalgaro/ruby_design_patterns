

class PaymentGateway
  def charge(amount_cents:, currency:, customer_id:)
    raise NotImplementedError, "Concrete implementation required"
  end

  def refund(payment_id:)
    raise NotImplementedError, "Concrete implementation required"
  end
end