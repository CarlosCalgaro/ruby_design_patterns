require_relative 'stock.rb'

class Observer
  def update(stock)
    raise NotImplementedError, 'You must implement the update method'
  end
end

class PrioritizedObserver < Observer
  attr_reader :priority

  def initialize(priority)
    @priority = priority
  end
end

class PriceDisplay < Observer
  def update(stock)
    puts "[PriceDisplay] #{stock.symbol}: $#{'%.2f' % stock.price}"
  end
end

class PriceAlertSystem < Observer
  def initialize(high_threshold:, low_threshold:)
    @high_threshold = high_threshold
    @low_threshold = low_threshold
  end

  def update(stock)
    if stock.price >= @high_threshold
      puts "[PriceAlert] 🚨 HIGH ALERT: #{stock.symbol} crossed $#{@high_threshold} threshold!"
    elsif stock.price <= @low_threshold
      puts "[PriceAlert] 🚨 LOW ALERT: #{stock.symbol} dropped below $#{@low_threshold} threshold!"
    end
  end
end

class StatisticsDisplay < Observer

  def initialize
    @prices = []
  end

  def update(stock)
    @prices << stock.price
    min = @prices.min
    max = @prices.max
    avg = (@prices.sum / @prices.size).round(2)
    puts "[Statistics] Min: $#{'%.2f' % min}, Max: $#{'%.2f' % max}, Avg: $#{'%.2f' % avg}"
  end
end

class TradingBot < Observer
  def initialize(buy_below:, sell_above:)
    @buy_below = buy_below
    @sell_above = sell_above
  end

  def update(stock)
    if stock.price <= @buy_below
      puts "[TradingBot] BUY signal triggered at $#{'%.2f' % stock.price}"
    elsif stock.price >= @sell_above
      puts "[TradingBot] SELL signal triggered at $#{'%.2f' % stock.price}"
    end
  end
end

# Bonus point 1 : Prioritized Observer
class HighFrequencyTradingBot < PrioritizedObserver
  def initialize(priority:, buy_below:, sell_above:)
    super(priority)
    @buy_below = buy_below
    @sell_above = sell_above
  end

  def update(stock)
    if stock.price <= @buy_below
      puts "[HighFrequencyTradingBot] QUICK BUY at $#{'%.2f' % stock.price}"
    elsif stock.price >= @sell_above
      puts "[HighFrequencyTradingBot] QUICK SELL at $#{'%.2f' % stock.price}"
    end
  end
end

class AuditLogger < Observer
  def update(stock)
    puts("[Audit Log] #{Time.now}: #{stock.symbol} price updated to $#{'%.2f' % stock.price}")
  end
end

# Example usage:
# Create stock subject
apple = Stock.new("AAPL", "Apple Inc.", 150.00)

# Create observers
price_display = PriceDisplay.new
alert_system = PriceAlertSystem.new(high_threshold: 160, low_threshold: 140)
stats_display = StatisticsDisplay.new
trading_bot = TradingBot.new(buy_below: 145, sell_above: 155)
hft_bot = HighFrequencyTradingBot.new(priority: 1, buy_below: 142, sell_above: 158)
audit_logger = AuditLogger.new


# Subscribe observers
apple.attach(price_display)
apple.attach(alert_system)
apple.attach(stats_display)
apple.attach(trading_bot)
apple.attach(hft_bot) # High priority observer at the front
apple.attach(audit_logger)

# Update price - all observers notified
apple.price = 155.00
# => [PriceDisplay] AAPL: $155.00
# => [Statistics] Min: $150.00, Max: $155.00, Avg: $152.50
# => [TradingBot] SELL signal triggered at $155.00
# => [Audit Log] 2026-01-20 08:03:40 -0300: AAPL price updated to $155.00

apple.price = 165.00
# => [HighFrequencyTradingBot] QUICK SELL at $165.00
# => [PriceDisplay] AAPL: $165.00
# => [PriceAlert] 🚨 HIGH ALERT: AAPL crossed $160.00 threshold!
# => [Statistics] Min: $150.00, Max: $165.00, Avg: $156.67
# => [Audit Log] 2026-01-20 08:03:40 -0300: AAPL price updated to $165.00

# Unsubscribe an observer
apple.detach(trading_bot)

apple.price = 140.00
# => [HighFrequencyTradingBot] QUICK BUY at $140.00
# => [PriceDisplay] AAPL: $140.00
# => [PriceAlert] 🚨 LOW ALERT: AAPL dropped below $140.00 threshold!
# => [Statistics] Min: $140.00, Max: $165.00, Avg: $152.50
# => [Audit Log] 2026-01-20 08:03:40 -0300: AAPL price updated to $140.00


apple.batch_update do |stock|
  stock.price = 138.00
  stock.price = 142.00
  stock.price = 1.00
end

apple.notification_history.print_history