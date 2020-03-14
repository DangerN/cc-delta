class Delta

  # Configure the behavior of the server
  private def self.kemal_config
    ws "/" do |socket|
      @@updateTargets.push socket
      puts "Socket opened: #{socket}"
      socket.send Alpha.boards.to_json
      # Remove target from list on socket close.
      socket.on_close do |_|
        @@updateTargets.delete socket
        puts "Closed socket: #{socket}"
      end
    end

    options "/new" do |env|
      headers(env, {
        "Access-Control-Allow-Origin" => "*",
        "Access-Control-Allow-Headers" => "content-type"
        })
    end

    #
    post "/new" do |env|
      name = ""
      text = ""
      subject = ""
      thread = nil
      board_id = nil
      media = ""
      badges = [] of String
      flags = [] of String

      post_params = {} of String => String

      headers(env, {"Access-Control-Allow-Origin" => "*"})
      HTTP::FormData.parse(env.request) do |part|
        case part.name
        when "name"
          name = part.body.gets_to_end
          post_params.["name"] = part.body.gets_to_end
        when "text"
          text = part.body.gets_to_end
          post_params.["text"] = part.body.gets_to_end
        when "subject"
          subject = part.body.gets_to_end
          post_params.["subject"] = part.body.gets_to_end
        when "thread"
          thread = part.body.gets_to_end
          post_params.["thread"] = part.body.gets_to_end
        when "board"
          board_id = part.body.gets_to_end
          post_params.["board"] = part.body.gets_to_end
        when "file"
          if (!part.filename.nil?)
            file_parts = part.filename.not_nil!.split('.')
            echo_connection = HTTP::Client.new(host: "0.0.0.0", port: "3001")
            headers = HTTP::Headers{
              "Content-Type"=>"application/octet-stream",
              "File-Name"=> file_parts[0],
              "File-Extension"=> file_parts[1]
            }
            media = file_parts[0]
            post_params.["media"] = file_parts[0]
            response = echo_connection.post("/media", headers: headers, body: part.body.gets_to_end)
          end
        end
      end

      if (thread != nil)
        db = DB.open "postgres://localhost:5432/cc-db"
        # board = Alpha.boards[board_id]
        p "attempt to insert into database"
        db.query("insert into \"#{board_id}_posts\" (badges, flags, media_name, subject, name, text, thread_id) values ($1, $2, $3, $4, $5, $6, $7) returning *;", badges, flags, media, subject, name, text, thread) do |rs|
          rs.each do
            id, badges, flags, media_name, subject, name, text, time_stamp =
              rs.read(Int64, Array(String), Array(String), String, String, String, String, Time)
              p "attempt to add post"
              Alpha.boards[board_id].threads[thread.to_s].posts.push(Alpha::Post.new(id.to_u64, name, subject, text, media_name, badges, flags, time_stamp))
          end
        end
        db.close
      end

      if (thread == nil)
        p "attempt to start new thread"
        db = DB.open "postgres://localhost:5432/cc-db"
        db.query("insert into \"#{board_id}_threads\" (flags) values ($1) returning *", flags) do |rs|
          p "added thread"
          rs.each do
            id, flags, post_limit = rs.read(Int32, Array(String), Int16)
            thread = id
            p "inserting thread"
            Alpha.boards[board_id].threads[thread.to_s] = Alpha::Thread.new(id.to_u64, flags, post_limit.to_u16)
            p "inserted thread"
          end
        end

        p "adding post"
        db.query("insert into \"#{board_id}_posts\" (badges, flags, media_name, subject, name, text, thread_id) values ($1, $2, $3, $4, $5, $6, $7) returning *;", badges, flags, media, subject, name, text, thread) do |rs|
          rs.each do
            id, badges, flags, media_name, subject, name, text, time_stamp =
              rs.read(Int64, Array(String), Array(String), String, String, String, String, Time)
              Alpha.boards[board_id].threads[thread.to_s].posts.push(Alpha::Post.new(id.to_u64, name, subject, text, media_name, badges, flags, time_stamp))
          end
        end

        db.close
        p thread
      end

      @@updateTargets.each { |socket| socket.send Alpha.boards.to_json }

      "nerd"
    end

    get "/test" do |env|
      headers(env, {"Access-Control-Allow-Origin" => "*"})
      "seems ok"
    end

    Kemal.config.port = 9002
  end
end
