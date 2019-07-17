# frozen_string_literal: true

class ApplicationMetricsBuilder
  class << self
    def last_successful_update
      [
        "last_successful_update #{Project.maximum(:updated_at).to_i}",
        "db_connection #{ApplicationStatusChecker.db_status}",
        "gitlab_connection #{ApplicationStatusChecker.gitlab_status}"
      ].join("\n")
    end
  end
end
