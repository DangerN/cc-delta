class Delta
  private def self.kemal_config
    ws "/" do |socket|
      @@updateTargets.push socket
      socket.send CC.boards[0].to_json

      socket.on_close do |_|
        CC.sockets.delete(socket)
        puts "Closed socket: #{socket}"
      end
    end

    options "/new" do |env|
      headers(env, {
        "Access-Control-Allow-Origin" => "*",
        "Access-Control-Allow-Headers" => "content-type"
        })
    end

    post "/new" do |env|
      headers(env, {"Access-Control-Allow-Origin" => "*"})
      yeem = JSON.parse(env.request.body.not_nil!).as_h
      # CC.validate_create yeem
      puts yeem["board"]
      post_settings =
      thread_settings =
      puts "board:#{yeem["board"]}:threads"

      puts "{}"
      "nerd"
    end

    get "/test" do |env|
      headers(env, {"Access-Control-Allow-Origin" => "*"})
      "seems ok"
    end

    Kemal.config.port = 9002
  end
end
