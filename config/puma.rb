# frozen_string_literal: true

require "dotenv/load"

port ENV.fetch("IRIS_APP_PORT") { 3000 }
environment ENV.fetch("RACK_ENV") { "development" }
