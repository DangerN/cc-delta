class Delta
  def self.load_image
    db = DB.open "postgres://localhost:5432/cc-db"

    db.query "select * from boards" do |rs|
      rs.each do
        id, name, flags, thread_limit = rs.read(String, String, Array(String), Int16)
        Alpha.boards[id] = Alpha::Board.new(id, name, flags, thread_limit)
      end
    end

    Alpha.boards.each_key do |board|
      db.query "select * from \"3_threads\"" do |rs|
        rs.each do
          id, flags, post_limit = rs.read(Int32, Array(String), Int16)
          Alpha.boards[board].threads[id.to_s] = Alpha::Thread.new(id.to_u64, flags, post_limit.to_u16)
        end
      end
    end

    db.close
  end
end
