# frozen_string_literal: true

module IrisLogger
  extend ActiveSupport::Concern

  included do
    configure :production, :development do
      enable :logging
      use Rack::CommonLogger, IrisLogger.logger
    end

    before { env["rack.errors"] = STDOUT }
  end

  class << self
    def logger
      @logger ||= ::Logger.new(STDOUT)
    end
  end
end
