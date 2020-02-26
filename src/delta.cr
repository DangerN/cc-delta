require "kemal"
require "redis"
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

module Alpha
  class Post
    def initialize(id, name, subject, text, media_name)
      @id = id
      @name = name
      @subject = subject
      @text = text
      @media_name = media_name
      @badges = [] of String
      @flags = [] of String
    end
  end
end

# Delta.run
