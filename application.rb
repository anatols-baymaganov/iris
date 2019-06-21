# frozen_string_literal: true

require "sinatra"
require "sinatra/json"
require "sinatra/activerecord"

require File.expand_path("lib/require_libs.rb", __dir__)

module Iris
  class Application < ::Sinatra::Base
    set :views, -> { File.join(root, "app/views") }
    set :method_override, true

    register ::Sinatra::ActiveRecordExtension

    helpers do
      def partial(view, options = {})
        erb(view, options.merge(layout: false))
      end
    end

    before %r{/|/requirements} do
      @requirements = VersionsSettings.requirements
    end

    before %r{/requirements} do
      @versions_settings = VersionsSettings.all.to_a
    end

    get "/" do
      erb(:root)
    end

    get "/versions.json" do
      json DataTablesService.new(params).json
    end

    get "/requirements" do
      erb(:requirements)
    end

    patch "/requirements" do
      @errors = VersionsSettings.update_requirements(requirements_params)
      redirect "/" if @errors.empty?
      erb(:requirements)
    end

    post "/load_versions" do
      AvailableVersionsUpdater.update
      redirect "/requirements"
    end

    private

    def requirements_params
      params.slice(*VersionsCheckingConfig.check_versions_for)
    end
  end
end
