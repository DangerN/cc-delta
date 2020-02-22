class Delta
  def self.load_image
    # test_board
    # board_by_id("test").add_thread(%({"id":0,"flags":["sfw"],"posts":[{"id":0,"badges":[],"flags":[],"name":"yingus","text":"I am lonely post!","media_name":"cute-potato"}]}))
    board_list = @@redis.lrange("board_list", "0", "-1")
    board_list.not_nil!.each do |board_id|
      board_meta = @@redis.hgetall("board:#{board_id}").not_nil!
      board_hash = {} of String => String
      while board_meta.size > 1
        board_hash[board_meta.shift.to_s] = board_meta.shift.to_s
      end
      p board_hash
      board = Alpha::Board.new(board_hash["id"],board_hash["name"])
      p board
      @@redis.keys("board:#{board_id}:thread:*").not_nil!.each do |thread|
        p @@redis.lrange(thread.to_s, "0", "-1")
      end

    end
  end
end
