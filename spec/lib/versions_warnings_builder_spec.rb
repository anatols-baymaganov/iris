# frozen_string_literal: true

require File.expand_path("../spec_helper.rb", __dir__)

RSpec.describe VersionsWarningsBuilder do
  let!(:requirements) do
    FactoryBot::Helper.init_requirements(ruby:       "2.5.1",
                                         rails:      "4.2.11.1",
                                         rake:       "10.0",
                                         bundler:    "1.17.2",
                                         capistrano: "3.6.1")
  end
  let(:subject) { described_class.new(project, ProjectDecorator.new(project).send(:project_versions_hash)) }

  describe "#version_warning" do
    context "when Project with low gem's versions" do
      let(:project) do
        create(:project, ruby:       "2.3.3",
                         rails:      "3.1",
                         rake:       "0.9.6",
                         bundler:    "1.16.3",
                         capistrano: "3.3.3")
      end

      context "it should return warning message for Ruby version" do
        it "should return warning message" do
          expect(subject.version_warning("ruby")).to eq("Ruby версия ниже минимально установленной")
        end
      end

      context "it should return warning message for Rails" do
        it "should return warning message" do
          expect(subject.version_warning("rails")).to eq("Rails версия ниже минимально установленной")
        end
      end
    end

    context "when Project with good gem's versions" do
      let(:project) do
        create(:project, ruby:       "2.6.3",
                         rails:      "5.0.0.1",
                         rake:       "12.0",
                         bundler:    "1.17.2",
                         capistrano: "3.6.1")
      end

      context "it should return warning message for Bundler" do
        it "should not return warning message" do
          expect(subject.version_warning("bundler")).to be_nil
        end
      end

      context "it should return warning message for Rake" do
        it "should not return warning message" do
          expect(subject.version_warning("rake")).to be_nil
        end
      end
    end
  end

  describe "#capistrano_ruby_compatibility_warning" do
    context "when capistrano's ruby version is specified on Project" do
      context "and Project's ruby version equal ruby version in config/deploy.rb " do
        let(:project) { create(:project, ruby: "2.3.3", capistrano_ruby: "2.3.3") }

        it "should not return warning message" do
          expect(subject.capistrano_ruby_compatibility_warning).to be_nil
        end
      end

      context "and Project's ruby version doesn't equal ruby version in config/deploy.rb " do
        let(:project) { create(:project, ruby: "2.3.3", capistrano_ruby: "2.3.4") }
        let(:warning_mess) { "Версия ruby в capistrano deploy файле не соответствует версии ruby проекта" }

        it "should return warning message" do
          expect(subject.capistrano_ruby_compatibility_warning).to eq(warning_mess)
        end
      end
    end
  end

  describe "#rails_dependency_warnings" do
    context "when all dependency is good" do
      let(:project) { create(:project, ruby: "1.8.7", rails: "3.1", bundler: "1.3.0") }

      it "should return empty array" do
        expect(subject.rails_dependency_warnings).to eq([])
      end
    end

    context "when all dependency is bad" do
      let(:project) { create(:project, ruby: "1.8.0", rails: "3.1", bundler: "0.9") }

      it "should return array with warning messages about ruby and bundler versions" do
        expect(subject.rails_dependency_warnings.size).to eq(2)
      end
    end
  end
end
