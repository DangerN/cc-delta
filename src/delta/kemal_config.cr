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
      # name = ""
      # text = ""
      # subject = ""
      # thread = nil
      # board_id = nil
      # media = ""
      # badges = [] of String
      # flags = [] of String

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

      if (post_params["thread"] != nil)
        handle_new_post(post_params)
      else
        handle_new_thread(post_params, [""])
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
