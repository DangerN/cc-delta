require "kemal"
require "redis"
require "cc-alpha"
require "./delta/*"


# post_json = redis.lindex("board:test:thread:1:posts", "0")
#
# p post_json
# if (!post_json.nil?)
#   post = Alpha::Post.from_json(post_json)
# end
#
# p post

class Delta
  VERSION = "0.1.0"
  @@updateTargets = [] of HTTP::WebSocket
  @@redis = Redis.new

  def self.run
    # kemal_config
    load_image
    # Kemal.run
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
    def initialize(id, name, @flags = [] of String, @thread_limit = 25.to_u8 , @threads = {} of String => Thread , @post_count = 0.to_u64, @thread_count = 0.to_u64)
      @id = id
      @name = name
    end
  end
end

Delta.run
