🎯 Challenge: Abstract Factory (real backend scenario)

Scenario

You’re building a checkout system that supports multiple payment providers.
Each provider requires a consistent set of components that must match:

Family of products (3 objects):
	1.	PaymentClient – charges / refunds
	2.	WebhookVerifier – verifies webhook signatures
	3.	ReceiptFormatter – formats receipts (string / hash)

You must support two providers:
	•	Stripe
	•	MercadoPago

Rules
	•	Your app receives provider as "stripe" or "mercadopago".
	•	The rest of the system must work with interfaces, not concrete classes.
	•	When you switch providers, you must switch the whole family consistently.
	•	Adding a new provider later must require creating a new factory + concrete classes, not editing the business logic.

⸻

Requirements

1) Define abstract product interfaces

Implement these base interfaces (Ruby base classes with raise NotImplementedError is fine):
	•	PaymentClient
    •	charge(amount_cents:, currency:, customer_id:) -> payment_id
    •	refund(payment_id:) -> refund_id
	•	WebhookVerifier
	  •	verify(signature:, payload:) -> true/false
	•	ReceiptFormatter
	  •	format(payment_id:, amount_cents:, currency:) -> String

2) Implement concrete products for each provider

You’ll end up with 6 concrete classes, for example:

Stripe family
	•	StripePaymentClient
	•	StripeWebhookVerifier
	•	StripeReceiptFormatter

MercadoPago family
	•	MercadoPagoPaymentClient
	•	MercadoPagoWebhookVerifier
	•	MercadoPagoReceiptFormatter

Implementations can be mocked (just puts and return fake IDs), but behavior should differ a bit per provider (e.g., receipt format prefixes, signature rules).

3) Implement the Abstract Factory interface

Create an abstract factory:
	•	PaymentsProviderFactory
    •	payment_client
    •	webhook_verifier
    •	receipt_formatter

Then implement:
	•	StripeFactory < PaymentsProviderFactory
	•	MercadoPagoFactory < PaymentsProviderFactory

4) Create a small “business service” that uses ONLY the abstract factory

Create CheckoutService that receives a factory instance:
	•	checkout(amount_cents:, currency:, customer_id:)
	•	uses factory.payment_client.charge(...)
	•	uses factory.receipt_formatter.format(...)
	•	returns receipt string

And create WebhookService:
	•	handle_webhook(signature:, payload:)
	•	uses factory.webhook_verifier.verify(...)
	•	returns "ok" or "invalid"

✅ Constraint: CheckoutService and WebhookService must not reference Stripe or MercadoPago classes directly.
