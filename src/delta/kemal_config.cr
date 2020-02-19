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
      name = nil
      text = nil
      subject = nil
      thread = nil
      board_id = nil
      file = nil
      # file_data = nil

      headers(env, {"Access-Control-Allow-Origin" => "*"})
      HTTP::FormData.parse(env.request) do |part|
        case part.name
        when "name"
          name = part.body.gets_to_end
        when "text"
          text = part.body.gets_to_end
        when "subject"
          subject = part.body.gets_to_end
        when "thread"
          thread = part.body.gets_to_end
        when "board"
          board_id = part.body.gets_to_end
        when "file"
          file = part
          echo_connection = HTTP::Client.new(host: "0.0.0.0", port: "3001")
          p part.headers
          response = echo_connection.post("/delta", headers: part.headers, body: part.body)
          p response
        end
      end

      if (thread != nil)
        board = Alpha.boards[board_id]
        board.post_count += 1
        new_post = Alpha::Post.new(board.post_count, name.not_nil!, subject.not_nil!, text.not_nil!, "")
        board.threads[thread].posts.push(new_post)
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
