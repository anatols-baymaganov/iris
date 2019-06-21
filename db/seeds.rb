# frozen_string_literal: true

puts "Load available versions list from Internet"
AvailableVersionsUpdater.update

puts "Initialize minimal version requirements"
errors = VersionsSettings.update_requirements({
                                                ruby:       "2.3.3",
                                                rails:      "4.2.11.1",
                                                rake:       "10.0",
                                                bundler:    "1.17.2",
                                                capistrano: "3.6.1"
                                              }, strict: false)
puts errors if errors.present?
