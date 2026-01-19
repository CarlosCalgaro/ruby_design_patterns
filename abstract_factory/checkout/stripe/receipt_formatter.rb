module Stripe
  class ReceiptFormatter < ReceiptFormatter
    def format(payment_id:, amount_cents:, currency:)
      "Stripe Receipt - Payment ID: #{payment_id}, Amount: #{amount_cents} #{currency}"
    end
  end
end