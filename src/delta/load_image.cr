class Delta
  def self.load_image
    test_board
    board_by_id("test").add_thread(%({"id":0,"flags":["sfw"],"posts":[]}))
  end
end
