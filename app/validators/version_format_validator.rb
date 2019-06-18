# frozen_string_literal: true

class VersionFormatValidator < ActiveModel::EachValidator
  def validate_each(record, _attribute, value)
    incorrect_versions = [*value].select { |version| version.blank? || !Gem::Version.correct?(version) }
    return if incorrect_versions.blank?

    record.errors.add(record.key, "неправильный формат версии: #{incorrect_versions.map(&:inspect).join(', ')}")
  end
end
