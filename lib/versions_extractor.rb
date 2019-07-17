# frozen_string_literal: true

class VersionsExtractor
  VERSION_REGEXP = /(\d+)(\.\d+)+/.freeze

  def initialize(ruby_version, gem_file_lock, deploy_file)
    @ruby_version_file = ruby_version
    @gem_file_lock = gem_file_lock
    @deploy_file = deploy_file
  end

  def ruby_version
    from_version_file = ruby_version_file.exists? && ruby_version_file.content.split("\n").first.to_s[VERSION_REGEXP]
    from_gem_file = bundler_parser.ruby_version.to_s[VERSION_REGEXP]
    from_version_file || from_gem_file
  end

  def gem_version(gem)
    bundler_parser.specs.find { |spec| spec.name.to_s == gem.to_s }&.version&.to_s
  end

  def bundler_version
    bundler_parser.bundler_version&.to_s
  end

  def capistrano_ruby_version
    return unless gem_version("capistrano").present? && deploy_file.exists?

    ruby_version_string = deploy_file.content.split("\n").find { |line| line.include?("rvm_ruby_version") }.to_s
    ruby_version_string[VERSION_REGEXP]
  end

  private

  attr_reader :ruby_version_file, :gem_file_lock, :deploy_file

  def bundler_parser
    @bundler_parser ||= Bundler::LockfileParser.new(gem_file_lock.content.to_s)
  end

  def method_missing(method_name)
    super unless VersionsCheckingConfig.check_versions_for.include?(method_name.to_s)

    if %i[ruby bundler capistrano_ruby].include?(method_name)
      public_send("#{method_name}_version")
    else
      public_send(:gem_version, method_name)
    end
  end

  def respond_to_missing?(name, include_private = false)
    VersionsCheckingConfig.check_versions_for.include?(name) || super
  end
end
