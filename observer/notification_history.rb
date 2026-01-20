
class NotificationHistory
  
  def initialize(max_entries: 1_000_000)
    @notification_history = []
    @max_entries = max_entries
    @mutex = Mutex.new
  end

  def log(stock, observer)
    @mutex.synchronize do
      @notification_history << {
        at: Time.now,
        symbol: stock.symbol,
        from: stock.previous_price,
        to: stock.price,
        observer: observer.class.name,
        note: "price changed",
        thread_id: Thread.current.object_id,
        thread_name: Thread.current.name || "thread-#{Thread.current.object_id}"
      }
      @notification_history.shift if @notification_history.size > @max_entries
    end
  end

  def print_history
    puts "Notification History:"
    @notification_history.each do |note|
      puts "[#{note[:at]}] #{note[:observer]} notified of #{note[:symbol]} price change from $#{'%.2f' % note[:from]} to $#{'%.2f' % note[:to]} - #{note[:note]} using #{note[:thread_name]} (ID: #{note[:thread_id]})"
    end
  end
end