class Delta
  def self.process_formData(request)
    post_params = {} of String => String

    HTTP::FormData.parse(request) do |part|
      case part.name
      when "name"
        post_params.["name"] = part.body.gets_to_end
      when "text"
        post_params.["text"] = part.body.gets_to_end
      when "subject"
        post_params.["subject"] = part.body.gets_to_end
      when "thread"
        post_params.["thread"] = part.body.gets_to_end
      when "board"
        post_params.["board"] = part.body.gets_to_end
      when "file"
        if (!part.filename.nil?)
          file_parts = part.filename.not_nil!.split('.')
          echo_connection = HTTP::Client.new(host: "0.0.0.0", port: "3001")
          headers = HTTP::Headers{
            "Content-Type"   => "application/octet-stream",
            "File-Name"      => file_parts[0],
            "File-Extension" => file_parts[1],
          }
          post_params.["media"] = file_parts[0]
          # TODO: This needs to verify successful upload and handle failure
          response = echo_connection.post("/media", headers: headers, body: part.body.gets_to_end)
        end
      end
    end
    post_params
  end

  def self.handle_new_post(params)
    db = DB.open "postgres://localhost:5432/cc-db"
    board_id = params["board_id"]
    thread = params["thread"]
    db.query("insert into \"#{params["board_id"]}_posts\" (badges, flags, media_name, subject, name, text, thread_id) values ($1, $2, $3, $4, $5, $6, $7) returning *;", params["badges"], params["flags"], params["media"], params["subject"], params["name"], params["text"], params["thread"]) do |rs|
      rs.each do
        id, badges, flags, media_name, subject, name, text, time_stamp =
          rs.read(Int64, Array(String), Array(String), String, String, String, String, Time)
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
      rs.each do
        id, flags, post_limit = rs.read(Int32, Array(String), Int16)
        thread = id.not_nil!
        Alpha.boards[board_id].threads[thread.to_s] = Alpha::Thread.new(id.to_u64, flags, post_limit.to_u16)
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
  end
end
