require_relative '../receipt_formatter'

module MercadoPago
  class ReceiptFormatter < ReceiptFormatter
    def format(payment_id:, amount_cents:, currency:)
      "Mercado Pago Receipt - Payment ID: #{payment_id}, Amount: #{amount_cents} #{currency}"
    end
  end
end