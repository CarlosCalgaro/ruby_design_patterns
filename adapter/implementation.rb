require_relative 'payment_gateway'

class LegacyPaySDK
  def make_payment(total:, user_ref:)
    "legacy_pay_#{rand(1000)}"
  end

  def cancel_payment(transaction_code)
    "legacy_refund_#{transaction_code}"
  end
end


class LegacyPayAdapter < PaymentGateway

  def initialize(sdk)
    @legacy_pay_sdk = sdk
  end

  def charge(amount_cents:, currency:, customer_id:)
    @legacy_pay_sdk.make_payment(total: amount_cents, user_ref: customer_id)
  end

  def refund(payment_id:)
    @legacy_pay_sdk.cancel_payment(payment_id)
  end
end

class BillingService
  def initialize(payment_gateway)
    @payment_gateway = payment_gateway
  end

  def charge_customer(amount_cents, customer_id)
    @payment_gateway.charge(amount_cents: amount_cents, currency: "USD", customer_id: customer_id)
  end

  def refund_payment(payment_id)
    @payment_gateway.refund(payment_id: payment_id)
  end
end

gateway = LegacyPayAdapter.new(LegacyPaySDK.new)
billing = BillingService.new(gateway)

payment_id = billing.charge_customer(5000, "cus_123")
refund_id  = billing.refund_payment(payment_id)

puts "Payment ID: #{payment_id}"
puts "Refund ID: #{refund_id}"