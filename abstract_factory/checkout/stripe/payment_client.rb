require_relative '../payment_client'

module Stripe
  class PaymentClient < PaymentClient
    def charge(amount_cents:, currency:, customer_id:)
      puts("Charging #{amount_cents} #{currency} to customer #{customer_id} via Stripe")
      return { payment_id: "stripe_#{rand(1000..9999)}", amount_cents:, currency:, customer_id: }
    end

    def refund(payment_id:)
      puts("Refunding payment #{payment_id} via Stripe")
    end
  end
end