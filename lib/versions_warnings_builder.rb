# frozen_string_literal: true

class VersionsWarningsBuilder
  def initialize(project, versions)
    @project = project
    @project_versions = versions
  end

  def version_warning(subject)
    version = project_versions[subject]
    require_version = requirements[subject]
    return if version.blank? || require_version.blank?

    less_than_message(subject) if Gem::Version.new(require_version) > Gem::Version.new(version)
  end

  def capistrano_ruby_compatibility_warning
    return if project_versions[:ruby].blank? || project_versions[:capistrano_ruby].blank?
    return if Gem::Version.new(project_versions[:ruby]) == Gem::Version.new(project_versions[:capistrano_ruby])

    "Версия ruby в capistrano deploy файле не соответствует версии ruby проекта"
  end

  def rails_dependency_warnings
    return if project_versions[:rails].blank?

    dependencies = rails_dependency(project_versions[:rails])
    return if dependencies.blank?

    ruby_dependencies = fetch_dependencies_by_name(dependencies, :ruby)
    bundler_dependencies = fetch_dependencies_by_name(dependencies, :bundler)
    [
      versions_compatible?(ruby_dependencies, :ruby) ? nil : incompatible_versions_message(dependencies, :ruby),
      versions_compatible?(bundler_dependencies, :bundler) ? nil : incompatible_versions_message(dependencies, :bundler)
    ].compact
  end

  private

  attr_reader :project, :project_versions

  def rails_dependency(version)
    normalized_version = version.split(".").first.concat(".0")
    VersionsCheckingConfig.rails_dependency.dig(normalized_version)&.symbolize_keys
  end

  def fetch_dependencies_by_name(dependencies, name)
    dependencies[name].split(",").map { |dep| dep.strip.split(" ") }.to_h
  end

  def versions_compatible?(dependencies, subject)
    dependencies.all? do |operation, ver|
      Gem::Version.new(project_versions[subject]).public_send(operation, Gem::Version.new(ver))
    end
  end

  def less_than_message(subject)
    "#{subject.capitalize} версия ниже минимально установленной"
  end

  def incompatible_versions_message(dependencies, subject)
    "Версия Rails и #{subject.capitalize} не сочетаются: #{dependencies[subject]}"
  end

  def requirements
    @requirements ||= VersionsSettings.requirements
  end
end
