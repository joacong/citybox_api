module CityboxApi
  class Configuration
    attr_accessor :user, :key

    def initialize
      user = nil
      key = nil
    end
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end
end