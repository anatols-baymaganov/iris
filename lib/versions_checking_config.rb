# frozen_string_literal: true

class VersionsCheckingConfig
  class << self
    def check_versions_for
      config.fetch("check_versions_for").clone
    end

    private

    def config
      @config ||= begin
        config_file = File.join(Sinatra::Application.settings.root, "config/versions_checking.yml")
        YAML.safe_load(ERB.new(File.open(config_file).read).result)
      end
    end
  end
end
