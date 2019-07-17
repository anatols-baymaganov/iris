# frozen_string_literal: true

require File.expand_path("../spec_helper.rb", __dir__)

RSpec.describe ApplicationStatusChecker do
  around do |example|
    VCR.use_cassette("projects_json") { example.run }
  end

  before { allow(IrisLogger).to receive_message_chain(:logger, :error).and_return(nil) }

  describe ".application_status" do
    let(:status) { described_class.application_status }

    context "when database is not connected" do
      before { allow(ActiveRecord::Base).to receive(:connection).and_raise(StandardError) }

      it "should return status :err" do
        expect(status).to eq(:err)
      end
    end

    context "when gitlab response status is not 200" do
      before do
        allow(GitlabApi).to receive(:fetch_projects_json).and_raise(GitlabApi::BadResponse.new(302, {}))
      end

      it "should return status :err" do
        expect(status).to eq(:err)
      end
    end

    context "when database connected and gitlab connection is fine" do
      it "should return status :ok" do
        expect(status).to eq(:ok)
      end
    end
  end
end
