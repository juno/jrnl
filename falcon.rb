#!/usr/bin/env -S falcon-host
# frozen_string_literal: true

require "falcon/environment/rack"
require "io/endpoint/socket_endpoint"

hostname = File.basename(__dir__)

service hostname do
  include Falcon::Environment::Rack

  preload "preload.rb"

  count { ENV.fetch("WEB_CONCURRENCY", 1).to_i }

  port { ENV.fetch("PORT", 3000).to_i }

  endpoint do
    if ENV["LISTEN_FDS"].to_i > 0
      # systemd socket activation: fd=3 が最初のソケット
      IO::Endpoint.socket(Socket.for_fd(3, autoclose: false))
    else
      Async::HTTP::Endpoint.parse("http://0.0.0.0:9000")
        .with(protocol: Async::HTTP::Protocol::HTTP11)
    end
  end
end
