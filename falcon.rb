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
    Async::HTTP::Endpoint.parse("http://0.0.0.0:#{port}")
      .with(protocol: Async::HTTP::Protocol::HTTP11)
  end
end
