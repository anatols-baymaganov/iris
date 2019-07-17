# frozen_string_literal: true

require File.expand_path("../spec_helper.rb", __dir__)

RSpec.describe AvailableVersionsUpdater do
  describe ".update" do
    let(:ruby_versions) { %w[2.6.0-preview1 2.5.0 2.5.0-rc1 2.4.3 2.3.6 2.2.9 2.5.0-preview1 2.4.2 2.3.5] }
    let(:rails_versions) do
      %w[5.0.0.rc2 5.0.0.rc1 5.0.0.racecar1 5.0.0.beta4 5.0.0.beta3 5.0.0.beta2 5.0.0.beta1.1 5.0.0.beta1]
    end
    let(:rails_loaded_versions) do
      VCR.use_cassette("available_versions_list") do
        described_class.update
        VersionsSettings.find_by(key: "rails_available_versions").value
      end
    end
    let(:ruby_loaded_versions) do
      VCR.use_cassette("available_versions_list") do
        described_class.update
        VersionsSettings.find_by(key: "ruby_available_versions").value
      end
    end

    it "should load rails versions" do
      expect(rails_loaded_versions).to include(*rails_versions)
    end

    it "should load ruby versions" do
      expect(ruby_loaded_versions).to include(*ruby_versions)
    end
  end
end
