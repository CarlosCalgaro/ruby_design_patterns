Adapter — brief explanation

Adapter allows objects with incompatible interfaces to work together by translating one interface into another that the client expects.

Mental model:

“I already have something that works, but its interface doesn’t match what my system expects.”

You do not change the existing class.
You wrap it.

Classic cases:
	•	Integrating 3rd-party libraries
	•	Legacy code
	•	Different APIs with similar responsibilities

🎯 Challenge: Adapter (real backend scenario)

Scenario

You’re building a Payment Gateway abstraction in your backend.

Your system expects all payment providers to follow this interface:

```ruby
charge(amount_cents:, currency:, customer_id:) -> payment_id
refund(payment_id:) -> refund_id
```

The problem

You must integrate a legacy payment SDK you cannot modify.

It looks like this:

```ruby
class LegacyPaySDK
  def make_payment(total:, user_ref:)
    "legacy_pay_#{rand(1000)}"
  end

  def cancel_payment(transaction_code)
    "legacy_refund_#{transaction_code}"
  end
end
```

Issues:
	•	Method names don’t match
	•	Argument names don’t match
	•	Return values are fine but inconsistent
	•	You are not allowed to change LegacyPaySDK


Your task

1️⃣ Define the target interface

Create a base interface:

```ruby
PaymentGateway
  - charge(amount_cents:, currency:, customer_id:)
  - refund(payment_id:)
```

2️⃣ Implement an Adapter

Create:

```ruby
LegacyPayAdapter < PaymentGateway
```
Responsibilities:
	•	Wrap an instance of LegacyPaySDK
	•	Translate:
	•	charge(...) → make_payment(...)
	•	refund(...) → cancel_payment(...)
	•	Ignore currency (LegacyPay doesn’t support it)

⸻

3️⃣ Business service (must be adapter-agnostic)

Create a BillingService that:
	•	Receives a PaymentGateway
	•	Calls charge and refund
	•	Never references LegacyPaySDK directly


```ruby
gateway = LegacyPayAdapter.new(LegacyPaySDK.new)
billing = BillingService.new(gateway)

payment_id = billing.charge_customer(5000, "cus_123")
refund_id  = billing.refund_payment(payment_id)
```

Expected output (example):
```ruby
Charging customer cus_123 -> legacy_pay_742
Refunding payment legacy_pay_742 -> legacy_refund_legacy_pay_742
```

🚫 Common mistakes (avoid these)
	•	❌ Renaming methods inside LegacyPaySDK
	•	❌ Adding conditionals in BillingService
	•	❌ Returning lambdas instead of objects
	•	❌ Mixing Adapter with Factory or Strategy here§