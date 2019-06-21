# frozen_string_literal: true

class GitlabApi
  class BadResponse < StandardError
    attr_reader :status, :response_headers

    def initialize(status, response_headers)
      @status = status
      @response_headers = response_headers

      super("Status: #{status}\nHeaders: #{response_headers}")
    end
  end

  class << self
    def fetch_projects_json
      fetch_data_by_url(projects_url)
    end

    def fetch_file_content(project_id, file_path)
      content = fetch_data_by_url(file_url(project_id, file_path)).dig("content")
      Base64.decode64(content) if content.present?
    rescue BadResponse => e
      raise e unless e.status == 404
    end

    private

    def fetch_data_by_url(url)
      response = Faraday.get url do |request|
        request.headers["Private-Token"] = ENV["GITLAB_ACCESS_TOKEN"]
      end
      raise BadResponse.new(response.status, response.headers) unless response.status == 200

      JSON.parse(response.body)
    end

    def projects_url
      "#{ENV['GITLAB_URL']}/api/v4/projects"
    end

    def file_url(project_id, file_path)
      "#{projects_url}/#{project_id}/repository/files/#{CGI.escape(file_path)}?ref=master"
    end
  end
end
