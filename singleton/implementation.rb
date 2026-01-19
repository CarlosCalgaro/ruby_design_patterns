require 'json'

class Config
  SETTINGS_PATH = 'singleton/config.json'
  @instance = nil
  @mutex = Mutex.new
  private_class_method :new

  def self.mutex
    @mutex
  end

  def self.instance
    return @instance if @instance

    @mutex.synchronize do
      @instance ||= new
      @instance.send(:load_if_needed!)
    end

    @instance
  end

  def reload!(path: SETTINGS_PATH)
    @settings = JSON.parse(File.read(path))
  end

  def reset_for_tests!
    self.class.mutex.synchronize { @settings = nil }
  end

  def get(key)
    return nil if key.nil? || @settings.nil?

    path_splitten(key).reduce(@settings) do |current, k|
      current.is_a?(Hash) ? current[k] : nil
    end
  end

  def set(key, value)
    return if key.nil? || @settings.nil?
    keys = path_splitten(key)
    last_key = keys.pop

    self.class.mutex.synchronize do
      target = keys.reduce(@settings) do |current, k|
        current.is_a?(Hash) ? current[k] : nil
      end
      target[last_key] = value if target.is_a?(Hash)
    end
  end


  private

  def mutex
    self.class.mutex
  end

  def load_if_needed!
    @settings ||= File.exist?(SETTINGS_PATH) ? JSON.parse(File.read(SETTINGS_PATH)) : {}
  end

  def path_splitten(path)
    path.split('.')
  end
end
