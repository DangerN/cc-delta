require "kemal"
require "cc-alpha"
require "./delta/*"

module Delta
  VERSION = "0.1.0"
  @@redis = Redis.new
  @@updateTargets = [] of HTTP::WebSocket

  def self.run

  end
end

Delta.run
