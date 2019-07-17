# frozen_string_literal: true

require File.expand_path("../spec_helper.rb", __dir__)

RSpec.describe GitlabApi do
  describe ".fetch_projects_json" do
    let(:project_ids) do
      [191, 192, 195, 222, 228, 229, 233, 234, 235, 236, 239, 241, 261, 267, 272, 277, 282, 286, 292, 297]
    end
    let(:fetched_project_ids) do
      VCR.use_cassette("projects_json") { described_class.fetch_projects_json.map { |project| project["id"] } }
    end

    it "should return json projects' info" do
      expect(fetched_project_ids).to match_array(project_ids)
    end
  end

  describe ".fetch_file_content" do
    let(:file_content) { VCR.use_cassette(".ruby_version") { GitlabApi.fetch_file_content(95, ".ruby-version") } }
    let(:expected_content) { "2.4.4\n" }

    it "should return expected file content" do
      expect(file_content).to eq(expected_content)
    end
  end
end
