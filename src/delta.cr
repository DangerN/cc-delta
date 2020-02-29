require "db"
require "pg"
require "kemal"
require "cc-alpha"
require "./delta/*"

class Delta
  VERSION = "0.1.0"
  @@updateTargets = [] of HTTP::WebSocket

  def self.run
    kemal_config
    load_image
    Kemal.run
  end
end


Delta.run
