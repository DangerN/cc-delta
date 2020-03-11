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
    def initialize(args : Hash(String, String))
      @id = args["id"].to_u64
      @name = args["name"] || ""
      @subject = args["subject"] || ""
      @text = args["text"] || ""
      @media_name = args["media_name"] || ""
      @badges = JSON.parse(args["badges"]).as_a.map { |e| e.to_s } || [] of String
      @flags = JSON.parse(args["flags"]).as_a.map { |e| e.to_s } || [] of String
      @time_stamp = args["time_stamp"] || ""
    end
  end
end

Delta.run
