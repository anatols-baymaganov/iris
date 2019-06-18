# frozen_string_literal: true

require "rubygems"
require "bundler"
Bundler.require

require "require_all"
require_all __dir__
require_all File.join(__dir__, "..", "app/validators")
require_all File.join(__dir__, "..", "app/models")
