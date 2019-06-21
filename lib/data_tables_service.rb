# frozen_string_literal: true

class DataTablesService
  def self.columns
    @columns ||= VersionsCheckingConfig.check_versions_for.unshift("name").freeze
  end

  def initialize(params)
    @order_column_num = params[:order].present? ? params[:order].values[0][:column].to_i : 0
    @order_direct = params[:order].present? ? params[:order].values[0][:dir] : "asc"
    @start = params[:start].to_i
    @length = params[:length].to_i
  end

  def json
    data = filter_projects.map do |project|
      decorated = ProjectDecorator.new(project)

      [
        decorated.link,
        VersionsCheckingConfig.check_versions_for.map { |name| decorated.public_send(name) },
        decorated.version_warnings
      ].flatten
    end
    records_count = Project.count

    { recordsTotal: records_count, recordsFiltered: records_count, data: data }
  end

  private

  attr_reader :order_column_num, :order_direct, :start, :length

  def filter_projects
    column_name = self.class.columns[order_column_num]
    scope = Project.eager_load(:project_versions)
    order_str =
      if VersionsCheckingConfig.check_versions_for.include?(column_name)
        Arel.sql("CASE
                       WHEN project_versions.key = '#{column_name}'
                       THEN project_versions.value
                       ELSE '0.0.0'
                  END #{order_direct}")
      else
        "projects.#{column_name} #{order_direct}"
      end
    scope.order(order_str).to_a.slice(start, length)
  end
end
