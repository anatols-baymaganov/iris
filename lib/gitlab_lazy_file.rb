# frozen_string_literal: true

class GitlabLazyFile
  def initialize(project_id, file_path)
    @project_id = project_id
    @file_path = file_path
  end

  def exists?
    !content.nil?
  end

  def content
    return @content if defined?(@content)

    @content = GitlabApi.fetch_file_content(project_id, file_path)
  end

  private

  attr_reader :project_id, :file_path
end
