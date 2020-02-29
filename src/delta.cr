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
  class Board
    def initialize(id, name, flags, thread_limit)
      @id = id
      @name = name
      @flags = flags
      @threads = {} of String => Thread
      @thread_limit = thread_limit.to_u8 || 25.to_u8
      @post_count = 0.to_u64
      @thread_count = 0.to_u64
    end
  end
  class Thread
    def initialize(id, flags, post_limit)
      @id = id
      @flags = flags
      @post_limit = post_limit
      @posts = [] of Post
    end
  end
end

Delta.run
