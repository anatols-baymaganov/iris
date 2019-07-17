# frozen_string_literal: true

require File.expand_path("../spec_helper.rb", __dir__)

RSpec.describe ApplicationMetricsBuilder do
  describe ".last_successful_update" do
    let!(:projects) { create_list(:project, 3) }
    let(:last_successful_update) { described_class.last_successful_update.split("\n").first.split(" ").second.to_i }
    let(:db_connection) { described_class.last_successful_update.split("\n").second.split(" ").second }
    let(:gitlab_connection) { described_class.last_successful_update.split("\n").third.split(" ").second }

    context "when database is not connected" do
      it "should return correct last_successful_update" do
        expect(Project.maximum(:updated_at).to_i).to eq(last_successful_update)
      end

      it "should return db_connection :ok" do
        expect(db_connection).to eq("ok")
      end

      it "should return gitlab_connection :ok" do
        expect(gitlab_connection).to eq("ok")
      end
    end
  end
end
