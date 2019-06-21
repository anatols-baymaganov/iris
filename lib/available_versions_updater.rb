# frozen_string_literal: true

class AvailableVersionsUpdater
  class << self
    def update
      update_gems_versions
      update_ruby_versions
    end

    private

    def update_gems_versions
      %i[rails rake bundler capistrano].each do |gem|
        response = Faraday.get("https://rubygems.org/gems/#{gem}/versions")
        next unless response.status == 200

        available_versions = Nokogiri::HTML(response.body).css(".t-list__item").map(&:text)
        VersionsSettings.find_or_initialize_by(key: "#{gem}_available_versions").update(value: available_versions)
      end
    end

    def update_ruby_versions
      response = Faraday.get("https://www.ruby-lang.org/en/downloads/releases/")
      return unless response.status == 200

      available_versions = Nokogiri::HTML(response.body).css(".release-list tr").map do |tr|
        tds = tr.css("td")
        next if tds.blank?

        tds.first.text.split(" ").last
      end.compact
      VersionsSettings.find_or_initialize_by(key: "ruby_available_versions").update(value: available_versions)
    end
  end
end
