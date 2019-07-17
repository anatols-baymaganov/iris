# frozen_string_literal: true

class ApplicationStatusChecker
  class << self
    def application_status
      %i[db_status gitlab_status].all? { |method| ApplicationStatusChecker.public_send(method) == :ok } ? :ok : :err
    end

    def db_status
      ActiveRecord::Base.establish_connection
      ActiveRecord::Base.connection
      ActiveRecord::Base.connected? ? :ok : :err
    rescue StandardError => e
      IrisLogger.logger.error(e.message)
      :err
    end

    def gitlab_status
      GitlabApi.fetch_projects_json && :ok
    rescue GitlabApi::BadResponse => e
      IrisLogger.logger.error(e.message)
      :err
    end
  end
end
