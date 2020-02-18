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
      headers(env, {"Access-Control-Allow-Origin" => "*"})
      yeem = JSON.parse(env.request.body.not_nil!).as_h
      puts yeem
      "nerd"
    end

    get "/test" do |env|
      headers(env, {"Access-Control-Allow-Origin" => "*"})
      "seems ok"
    end

    Kemal.config.port = 9002
  end
end
