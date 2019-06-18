# frozen_string_literal: true

class VersionsSettings < ActiveRecord::Base
  validates :key, presence: true, uniqueness: true
  validates :value, version_format: true

  serialize :value

  def self.requirements
    @requirements ||= where(key: VersionsCheckingConfig.check_versions_for).pluck(:key, :value).to_h
  end

  def self.update_requirements(params, strict: true)
    errors = transaction do
      params.each_with_object({}) do |(key, value), err|
        record = strict ? find_by!(key: key) : find_or_initialize_by(key: key)
        record.update(value: value)
        next if record.errors.blank?

        err[key.to_sym] = record.errors.messages.values.first
      end
    end
    @requirements = nil if errors.blank?
    errors
  end
end
