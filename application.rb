# frozen_string_literal: true

require "sinatra"
require "sinatra/json"
require "sinatra/activerecord"

require File.expand_path("lib/require_libs.rb", __dir__)

module Iris
  class Application < ::Sinatra::Base
    register Sinatra::ActiveRecordExtension
  end
end
