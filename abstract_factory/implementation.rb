require_relative 'checkout/mercado_pago/payment_client'
require_relative 'checkout/mercado_pago/receipt_formatter'
require_relative 'checkout/mercado_pago/webhook_verifier'
require_relative 'checkout/stripe/payment_client'
require_relative 'checkout/stripe/receipt_formatter'
require_relative 'checkout/stripe/webhook_verifier'


class PaymentsProviderFactory
  def payment_client
    raise NotImplementedError, 'Subclasses must implement the payment_client method'
  end

  def receipt_formatter
    raise NotImplementedError, 'Subclasses must implement the receipt_formatter method'
  end

  def webhook_verifier
    raise NotImplementedError, 'Subclasses must implement the webhook_verifier method'
  end
end

class StripeFactory < PaymentsProviderFactory
  def payment_client
    Stripe::PaymentClient.new
  end

  def receipt_formatter
    Stripe::ReceiptFormatter.new
  end

  def webhook_verifier
    Stripe::WebhookVerifier.new
  end
end

class MercadoPagoFactory < PaymentsProviderFactory
  def payment_client
    MercadoPago::PaymentClient.new
  end

  def receipt_formatter
    MercadoPago::ReceiptFormatter.new
  end

  def webhook_verifier
    MercadoPago::WebhookVerifier.new
  end
end

class CheckoutService
  def initialize(factory_class:)
    @factory = factory_class.new
  end

  def checkout(amount_cents:, currency:, customer_id:)
    payment_client = @factory.payment_client
    payment_id = payment_client.charge(amount_cents:, currency:, customer_id:)
    receipt_formatter = @factory.receipt_formatter
    puts receipt_formatter.format(amount_cents:, currency:, payment_id: payment_id)
  end
end


checkout_service = CheckoutService.new(factory_class: MercadoPagoFactory)

checkout_service.checkout(
  amount_cents: 5000,
  currency: "USD",
  customer_id: "cust_123"
)

stripe_checkout_service = CheckoutService.new(factory_class: StripeFactory)

stripe_checkout_service.checkout(
  amount_cents: 5000,
  currency: "USD",
  customer_id: "cust_123"
)
