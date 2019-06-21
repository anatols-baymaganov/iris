# frozen_string_literal: true

module FactoryBot
  module Helper
    def self.init_requirements(versions = {})
      VersionsSettings.update_requirements({
                                             ruby:       versions[:ruby] || "2.3.3",
                                             rails:      versions[:rails] || "4.2.11.1",
                                             rake:       versions[:rake] || "10.0",
                                             bundler:    versions[:bundler] || "1.17.2",
                                             capistrano: versions[:capistrano] || "3.6.1"
                                           }, strict: false)
    end
  end
end
