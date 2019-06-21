# frozen_string_literal: true

require File.expand_path("../spec_helper.rb", __dir__)

RSpec.describe DataTablesService do
  let(:subject) { described_class.new(order: { "0": { column: 1, dir: "desc" } }, start: 1, length: 2) }
  let!(:requirements) { FactoryBot::Helper.init_requirements }
  let!(:project_first) { create(:project, ruby: "2.5.2") }
  let!(:project_second) { create(:project, ruby: "2.5.3") }
  let!(:project_third) { create(:project, ruby: "2.5.4") }

  describe "#json" do
    it "should be sorted descending and limited" do
      expect(subject.json[:data].map(&:second)).to eq(%w[2.5.3 2.5.2])
    end
  end
end
