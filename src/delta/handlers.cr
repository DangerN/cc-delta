class Delta
  def self.log_message(message)
    p message
  end

  def self.handle_new_post(params)
    db = DB.open "postgres://localhost:5432/cc-db"
    board_id = params["board_id"]
    thread = params["thread"]
    p "attempt to insert into database"
    db.query("insert into \"#{params["board_id"]}_posts\" (badges, flags, media_name, subject, name, text, thread_id) values ($1, $2, $3, $4, $5, $6, $7) returning *;", params["badges"], params["flags"], params["media"], params["subject"], params["name"], params["text"], params["thread"]) do |rs|
      rs.each do
        id, badges, flags, media_name, subject, name, text, time_stamp =
          rs.read(Int64, Array(String), Array(String), String, String, String, String, Time)
        p "attempt to add post"
        Alpha.boards[board_id].threads[thread.to_s].posts.push(Alpha::Post.new(id.to_u64, name, subject, text, media_name, badges, flags, time_stamp))
      end
    end
    db.close
  end

  def self.handle_new_thread(params, flags)
    p "attempt to start new thread"
    board_id = params["board_id"]
    thread = nil
    db = DB.open "postgres://localhost:5432/cc-db"
    db.query("insert into \"#{board_id}_threads\" (flags) values ($1) returning *", flags) do |rs|
      p "added thread"
      rs.each do
        id, flags, post_limit = rs.read(Int32, Array(String), Int16)
        thread = id.not_nil!
        p "inserting thread"
        Alpha.boards[board_id].threads[thread.to_s] = Alpha::Thread.new(id.to_u64, flags, post_limit.to_u16)
        p "inserted thread"
      end
    end

    p "adding post"
    db.query("insert into \"#{board_id}_posts\" (badges, flags, media_name, subject, name, text, thread_id) values ($1, $2, $3, $4, $5, $6, $7) returning *;", params["badges"], params["flags"], params["media"], params["subject"], params["name"], params["text"], thread) do |rs|
      rs.each do
        id, badges, flags, media_name, subject, name, text, time_stamp =
          rs.read(Int64, Array(String), Array(String), String, String, String, String, Time)
        Alpha.boards[board_id].threads[thread.to_s].posts.push(Alpha::Post.new(id.to_u64, name, subject, text, media_name, badges, flags, time_stamp))
      end
    end

    db.close
    p thread
  end
end
