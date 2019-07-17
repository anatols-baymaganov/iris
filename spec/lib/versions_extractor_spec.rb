# frozen_string_literal: true

require File.expand_path("../spec_helper.rb", __dir__)

RSpec.describe VersionsExtractor do
  let(:ruby_version_content) do
    VCR.use_cassette(".ruby_version") { GitlabApi.fetch_file_content(95, ".ruby-version") }
  end
  let(:ruby_version_file) do
    file = GitlabLazyFile.new(95, ".ruby_version")
    allow(file).to receive(:content).and_return(ruby_version_content)
    file
  end
  let(:gem_file_lock_content) do
    VCR.use_cassette("Gemfile.lock.without_ruby") { GitlabApi.fetch_file_content(95, "Gemfile.lock") }
  end
  let(:gem_file_lock) do
    file = GitlabLazyFile.new(95, "Gemfile.lock")
    allow(file).to receive(:content).and_return(gem_file_lock_content)
    file
  end
  let(:deploy_file_content) do
    VCR.use_cassette("deploy.rb") { GitlabApi.fetch_file_content(95, "config/deploy.rb") }
  end
  let(:deploy_file) do
    file = GitlabLazyFile.new(95, "config/deploy.rb")
    allow(file).to receive(:content).and_return(deploy_file_content)
    file
  end
  let(:versions_extractor) { described_class.new(ruby_version_file, gem_file_lock, deploy_file) }

  context "when .ruby_version file exists" do
    it "should extract version from .ruby_version file" do
      expect(versions_extractor.ruby_version).to eq("2.4.4")
    end
  end

  context "when there is no .ruby_version file" do
    let(:ruby_version_content) { nil }
    let(:gem_file_lock_content) do
      VCR.use_cassette("Gemfile.lock.with_ruby") { GitlabApi.fetch_file_content(229, "Gemfile.lock") }
    end

    it "should extract version from Gemfile.lock if it's possible" do
      expect(versions_extractor.ruby_version).to eq("2.5.3")
    end
  end

  context "when there is no .ruby_version file and Gemfile.lock without ruby version info" do
    let(:ruby_version_content) { nil }

    before { allow_any_instance_of(Bundler::LockfileParser).to receive(:ruby_version).and_return(nil) }

    it "should return nil" do
      expect(versions_extractor.ruby_version).to eq(nil)
    end
  end

  context "when Gemfile.lock is specified" do
    it "should extract rails version" do
      expect(versions_extractor.gem_version("rails")).to eq("4.2.9")
    end

    it "should extract rake version" do
      expect(versions_extractor.gem_version("rake")).to eq("12.0.0")
    end

    it "should extract bundler version" do
      expect(versions_extractor.bundler_version).to eq("1.16.6")
    end

    it "should extract capistrano version" do
      expect(versions_extractor.gem_version("capistrano")).to eq("3.8.2")
    end
  end

  context "when config/deploy.rb file is specified" do
    context "and capistrano gem exists" do
      it "should extract capistrano ruby version" do
        expect(versions_extractor.capistrano_ruby_version).to eq("2.4.4")
      end
    end

    context "and capistrano gem doesn't exist" do
      before { allow(versions_extractor).to receive(:gem_version).with("capistrano").and_return(nil) }

      it "should not extract capistrano ruby version" do
        expect(versions_extractor.capistrano_ruby_version).to be_nil
      end
    end
  end
end
