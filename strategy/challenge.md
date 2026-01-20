# Strategy Pattern

## Pattern Explanation

The Strategy pattern is a behavioral design pattern that defines a family of algorithms, encapsulates each one, and makes them interchangeable. It lets the algorithm vary independently from clients that use it.

Key components:
- **Strategy Interface**: Common interface for all algorithms
- **Concrete Strategies**: Different implementations of the algorithm
- **Context**: Maintains a reference to a strategy and delegates the work to it

## Challenge: Payment Processing System

You're building a payment system for an e-commerce platform that supports multiple payment methods. Each payment method has different validation rules, processing logic, and fee structures.

### Requirements

1. Create a payment system that supports multiple payment strategies:
   - **Credit Card**: Validate card number (16 digits), CVV (3 digits), expiry date, charge 2.9% + $0.30 fee
   - **PayPal**: Validate email format, charge 3.5% + $0.49 fee
   - **Bank Transfer**: Validate account number (8-12 digits), routing number (9 digits), charge flat $1.00 fee
   - **Cryptocurrency**: Validate wallet address (42 characters), charge 1% fee
2. Each strategy should:
   - Validate payment details
   - Calculate fees
   - Process the payment
   - Return success/failure with appropriate messages
3. The payment processor should:
   - Accept any strategy dynamically
   - Allow switching strategies at runtime
   - Process payments using the selected strategy

### Example Usage

```ruby
# Create payment processor
processor = PaymentProcessor.new

# Process with credit card
processor.strategy = CreditCardStrategy.new
result = processor.process_payment(
  amount: 100.00,
  details: {
    card_number: "4532015112830366",
    cvv: "123",
    expiry: "12/25"
  }
)
puts result.total  # => 103.20 (100 + 2.9% + 0.30)

# Switch to PayPal
processor.strategy = PayPalStrategy.new
result = processor.process_payment(
  amount: 100.00,
  details: { email: "user@example.com" }
)
puts result.total  # => 103.99 (100 + 3.5% + 0.49)

# Switch to crypto
processor.strategy = CryptoStrategy.new
result = processor.process_payment(
  amount: 100.00,
  details: { wallet: "0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb" }
)
puts result.total  # => 101.00 (100 + 1%)
```

### Bonus Points

- Implement a strategy selector that recommends the cheapest method - OK
- Add support for refunds with different rules per strategy
- Create a payment history tracker - OK
- Implement retry logic with exponential backoff for failed payments
