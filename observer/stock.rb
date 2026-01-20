require_relative 'notification_history'

class Stock

  attr_accessor :price, :symbol, :company_name, :previous_price
  attr_reader :observers, :notification_history

  def initialize(symbol, company_name, price)
    @notification_history = NotificationHistory.new
    @observers = []
    @notification
    @symbol = symbol
    @company_name = company_name
    @batch_mode = false
    @price_changed = false
    @price = price
  end

  def price=(new_price)
    raise ArgumentError, 'Price must be a positive number' if new_price < 0
    @price_changed = true
    @previous_price = @price
    @price = new_price
    notify_observers
  end

  def batch_update
    @batch_mode = true
    @price_changed = false
    yield self if block_given?
    @batch_mode = false

    notify_observers if @price_changed
    @price_changed = false
  end

  def attach(observer)
    @observers << observer
    @observers.sort_by! { |obs| obs.respond_to?(:priority) ? obs.priority : Float::INFINITY }
  end

  def detach(observer)
    @observers.delete(observer)
  end

  private

  def notify_observers(async: false)

    if async
      threads = []
      @observers.each do |observer|
        threads << Thread.new do
          observer.update(self)
          @notification_history.log(self, observer) if @notification_history
        end
      end
      threads.each(&:join)
    else
      return if @batch_mode
      @observers.each do |observer|
        observer.update(self)
        @notification_history.log(self, observer) if @notification_history
      end
    end
  end
end