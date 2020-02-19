class Delta
  def self.load_image
    test_board
    board_by_id("test").add_thread(%({"id":0,"flags":["sfw"],"posts":[{"id":0,"badges":[],"flags":[],"name":"yingus","text":"I am lonely post!","media_name":"cute-potato"}]}))
  end
end
