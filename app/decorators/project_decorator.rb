# frozen_string_literal: true

class ProjectDecorator < SimpleDelegator
  VersionsCheckingConfig.check_versions_for.each do |name|
    define_method(name) { project_versions_hash[name] }
  end

  def link
    "<a href=\"#{url}\" target=\"_blank\">#{name}</a>"
  end

  def version_warnings
    warnings_builder = VersionsWarningsBuilder.new(self, project_versions_hash)
    warnings = [
      VersionsCheckingConfig.check_versions_for.map { |name| warnings_builder.version_warning(name) },
      warnings_builder.capistrano_ruby_compatibility_warning,
      warnings_builder.rails_dependency_warnings
    ].flatten.compact.join("<br/>" * 2)
    return if warnings.blank?

    warnings
  end

  private

  def project_versions_hash
    @project_versions_hash ||= project_versions.pluck(:key, :value).to_h.with_indifferent_access
  end
end
