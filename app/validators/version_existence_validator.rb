# frozen_string_literal: true

class VersionExistenceValidator < ActiveModel::EachValidator
  def validate_each(record, _attribute, value)
    available_versions = VersionsSettings.find_by(key: "#{record.key}_available_versions")&.value

    return if available_versions.blank?
    return if available_versions.any? { |version| Gem::Version.new(version) == Gem::Version.new(value) }

    add_error(record)
  rescue ArgumentError => e
    add_error(record) && return if e.message.include?("Malformed version number string")
    raise e
  end

  private

  def add_error(record)
    record.errors.add(record.key, "указана несуществующая версия")
  end
end
