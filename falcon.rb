#!/usr/bin/env -S falcon-host
# frozen_string_literal: true

require "falcon/environment/rack"

hostname = File.basename(__dir__)

service hostname do
  include Falcon::Environment::Rack

  preload "preload.rb"

  count { ENV.fetch("WEB_CONCURRENCY", 1).to_i }

  port { ENV.fetch("PORT", 3000).to_i }

  endpoint do
    Async::HTTP::Endpoint
      .parse("http://0.0.0.0:#{port}")
      .with(protocol: Async::HTTP::Protocol::HTTP11)
  end

  endpoint do
    # If a socket has been passed from systemd, use that one.
    if ENV["LISTEN_FDS"]
      Async::IO::SharedEndpoint.bound(
        Async::HTTP::Endpoint.parse("http://localhost:3000"),
      )
    else
      Async::HTTP::Endpoint.parse("http://0.0.0.0:3000")
    end
  end
end
