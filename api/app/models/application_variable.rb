class ApplicationVariable
  def self.client
    new.client
  end

  def self.get(key)
    new.get(key)
  end

  def self.set(key, value)
    new.set(key, value)
  end

  def client
    @client ||= Redis.new(url: ENV.fetch('APPLICATION_VARIABLE_URL', 'redis://localhost:6379/12'))
  end

  def get(key)
    client.get key
  end

  def set(key, value)
    client.set key, value
  end
end