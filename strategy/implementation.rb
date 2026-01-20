require 'ostruct'
class Strategy
  def process(amount:, details:)
    raise NotImplementedError, "You must implement the process method"
  end

  def preview_total(amount:)
    raise NotImplementedError, "You must implement the preview_total method"
  end

  private

  def assert_positive_amount(amount)
    raise ArgumentError, "Amount must be positive" unless amount.is_a?(Numeric) && amount > 0
  end
end

class CreditCardStrategy < Strategy
  def process(amount:, details:)
    assert_positive_amount(amount)
    validate_card_details(details)
    OpenStruct.new(total: calculate_total(amount: amount).round(2), method: "Credit Card", details: masked_card(details))
  end

  def preview_total(amount:)
    assert_positive_amount(amount)
    calculate_total(amount: amount)
  end

  private

  def calculate_total(amount:)
    fee_percentage = 0.029
    fixed_fee = 0.30
    amount + (amount * fee_percentage) + fixed_fee
  end

  def validate_card_details(details)
    card = details[:card_number].to_s
    cvv = details[:cvv].to_s
    expiry = details[:expiry].to_s
    raise ArgumentError, "Card number must be 16 digits" unless card.match?(/^\d{16}$/)
    raise ArgumentError, "CVV must be 3 digits" unless cvv.match?(/^\d{3}$/)
    raise ArgumentError, "Expiry must be MM/YY" unless expiry.match?(%r{^(0[1-9]|1[0-2])/\d{2}$})
  end

  def masked_card(details)
    card = details[:card_number].to_s
    masked = card.gsub(/\d(?=\d{4})/, "*")
    details.merge(card_number: masked, cvv: "***")
  end
end

class PayPalStrategy < Strategy
  def process(amount:, details:)
    assert_positive_amount(amount)
    validate_email(details)
    OpenStruct.new(total: calculate_total(amount: amount).round(2), method: "PayPal", details: details)
  end

  def preview_total(amount:)
    assert_positive_amount(amount)
    calculate_total(amount: amount)
  end

  def calculate_total(amount:)
    fee_percentage = 0.035
    fixed_fee = 0.49
    amount + (amount * fee_percentage) + fixed_fee
  end

  def validate_email(details)
    email = details[:email].to_s
    raise ArgumentError, "Email is required" if email.empty?
    raise ArgumentError, "Email format is invalid" unless email.match?(/^[^\s@]+@[^\s@]+\.[^\s@]+$/)
  end
end

class CryptoStrategy < Strategy
  def process(amount:, details:)
    assert_positive_amount(amount)
    validate_wallet(details)
    OpenStruct.new(total: calculate_total(amount: amount).round(2), method: "Cryptocurrency", details: details)
  end

  def preview_total(amount:)
    assert_positive_amount(amount)
    calculate_total(amount: amount)
  end

  def calculate_total(amount:)
    fee_percentage = 0.01
    amount + (amount * fee_percentage)
  end

  def validate_wallet(details)
    wallet = details[:wallet].to_s
    raise ArgumentError, "Wallet address is required" if wallet.empty?
    raise ArgumentError, "Wallet must be 42 hexadecimal chars" unless wallet.match?(/^0x[0-9a-fA-F]{40}$/)
  end
end

class BankTransferStrategy < Strategy
  def process(amount:, details:)
    assert_positive_amount(amount)
    validate_bank_details(details)
    OpenStruct.new(total: calculate_total(amount: amount).round(2), method: "Bank Transfer", details: masked_details(details))
  end

  def preview_total(amount:)
    assert_positive_amount(amount)
    calculate_total(amount: amount)
  end

  private

  def calculate_total(amount:)
    fixed_fee = 1.00
    amount + fixed_fee
  end

  def validate_bank_details(details)
    account = details[:account_number].to_s
    routing = details[:routing_number].to_s
    raise ArgumentError, "Account number must be 8-12 digits" unless account.match?(/^\d{8,12}$/)
    raise ArgumentError, "Routing number must be 9 digits" unless routing.match?(/^\d{9}$/)
  end

  def masked_details(details)
    account = details[:account_number].to_s
    masked_account = account.gsub(/\d(?=\d{4})/, "*")
    details.merge(account_number: masked_account, routing_number: "*********")
  end
end

class PaymentProcessor
  attr_accessor :strategy
  attr_reader :payment_history
  def initialize
    @payment_history = []
  end

  def process_payment(amount:, details:)
    raise "Payment strategy not set" unless @strategy

    result = @strategy.process(amount: amount, details: details)
    log_payment(amount: amount, details: details, result: result)
    result 
  end

  def preview_total(amount:)
    raise "Payment strategy not set" unless @strategy

    @strategy.preview_total(amount: amount).round(2)
  end

  private

  def log_payment(amount:, details:, result:)
    @payment_history << {
      amount: amount,
      strategy: @strategy.class.name,
      details: details,
      result: result
    }
  end
end

class CheapestStrategySelector
  def initialize(strategies)
    @strategies = strategies
  end

  def select(amount:)
    raise ArgumentError, "No strategies available" if @strategies.empty?

    cheapest = @strategies.min_by { |strategy| strategy.preview_total(amount: amount) }
    cheapest
  end
end

# Create payment processor
processor = PaymentProcessor.new

cheapest_selector = CheapestStrategySelector.new([
  CreditCardStrategy.new,
  PayPalStrategy.new,
  CryptoStrategy.new,
  BankTransferStrategy.new
])

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
  details: { wallet: "0x742d35Cc6634C0532925a3b844Bc9e7595f0bEbe" }
)
puts result.total  # => 101.00 (100 + 1%)


puts "The Cheapest Strategy is: #{cheapest_selector.select(amount: 100.00).class.name}"

puts "Payment processing completed."


puts "Payment History:"
processor.payment_history.each do |history|
  puts "Payment of #{history[:amount]} via #{history[:strategy]} resulted in total #{history[:result].total}"
end