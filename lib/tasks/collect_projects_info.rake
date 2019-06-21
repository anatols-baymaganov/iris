# frozen_string_literal: true

require "ruby-progressbar"

desc "Collect information about gems' versions from enicad gitlab and save it in DB"
task :collect_projects_info do
  puts "Build projects list"
  projects_hash = GitlabApi.fetch_projects_json.map { |h| h.slice("id", "name", "web_url").symbolize_keys }
  puts "Total projects: #{projects_hash.count}"

  progressbar = ProgressBar.create(title: "Collect info:", total: projects_hash.count)
  projects_hash.each do |project_hash|
    files = %w[.ruby-version Gemfile.lock config/deploy.rb].map { |path| GitlabLazyFile.new(project_hash[:id], path) }
    versions_extractor = VersionsExtractor.new(*files)
    project = Project.where(origin_id: project_hash[:id]).first_or_initialize(name: project_hash[:name],
                                                                              url:  project_hash[:web_url])
    VersionsCheckingConfig.check_versions_for.each do |name|
      project.project_versions.find_or_initialize_by(key: name).update(value: versions_extractor.public_send(name))
    end
    project.updated_at = Time.now.utc
    project.save!
    progressbar.increment
  end
end
