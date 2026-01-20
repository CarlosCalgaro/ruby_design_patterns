# Observer Pattern

## Pattern Explanation

The Observer pattern is a behavioral design pattern that defines a one-to-many dependency between objects. When one object (subject) changes state, all its dependents (observers) are notified and updated automatically.

Key components:
- **Subject**: Maintains list of observers and notifies them of state changes
- **Observer**: Interface for objects that should be notified of changes
- **Concrete Observers**: Implement the observer interface and react to notifications

## Challenge: Stock Price Monitoring System

You're building a stock trading platform where multiple components need to react to price changes in real-time. Implement an observer system where different display components and alert systems respond to stock price updates.

### Requirements

1. Create a `Stock` subject that:
   - Maintains current price, symbol, and company name
   - Notifies observers when price changes
   - Allows observers to subscribe/unsubscribe
   - Tracks price history
2. Implement multiple observer types:
   - **PriceDisplay**: Shows current price in real-time
   - **PriceAlertSystem**: Sends alerts when price crosses thresholds (e.g., above $100 or below $50)
   - **StatisticsDisplay**: Shows min, max, average prices
   - **TradingBot**: Automatically executes trades based on price movements
3. Each observer should:
   - React differently to price changes
   - Be able to subscribe/unsubscribe dynamically
   - Maintain its own state based on notifications

### Example Usage

```ruby
# Create stock subject
apple = Stock.new("AAPL", "Apple Inc.", 150.00)

# Create observers
price_display = PriceDisplay.new
alert_system = PriceAlertSystem.new(high_threshold: 160, low_threshold: 140)
stats_display = StatisticsDisplay.new
trading_bot = TradingBot.new(buy_below: 145, sell_above: 155)

# Subscribe observers
apple.attach(price_display)
apple.attach(alert_system)
apple.attach(stats_display)
apple.attach(trading_bot)

# Update price - all observers notified
apple.price = 155.00
# => [PriceDisplay] AAPL: $155.00
# => [Statistics] Min: $150.00, Max: $155.00, Avg: $152.50
# => [TradingBot] SELL signal triggered at $155.00

apple.price = 165.00
# => [PriceDisplay] AAPL: $165.00
# => [PriceAlert] 🚨 HIGH ALERT: AAPL crossed $160.00 threshold!
# => [Statistics] Min: $150.00, Max: $165.00, Avg: $156.67

# Unsubscribe an observer
apple.detach(trading_bot)

apple.price = 140.00
# => [PriceDisplay] AAPL: $140.00
# => [PriceAlert] 🚨 LOW ALERT: AAPL dropped below $140.00 threshold!
# => [Statistics] Min: $140.00, Max: $165.00, Avg: $152.50
# (TradingBot not notified)
```

### Bonus Points

- Implement priority-based notification (critical observers notified first) - OK
- Add support for batch updates (notify only after multiple changes) - OK
- Create a notification history/audit log - OK 
- Implement async notifications using threads
