# frozen_string_literal: true

require "enicad_styling"
require "sinatra/activerecord/rake"
require "dotenv/load"

require File.expand_path("application.rb", __dir__)

require "require_all"
load_all "lib/tasks/*.rake"

task(:environment) {}

namespace :db do
  task :load_config do
  end
end
