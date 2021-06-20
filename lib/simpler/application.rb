require 'yaml'
require 'singleton'
require 'sequel'
require 'time'
require_relative 'router'
require_relative 'controller'
require_relative 'middleware/runtime'
require_relative 'middleware/log'

module Simpler
  class Application

    include Singleton

    attr_reader :db

    def initialize
      @router = Router.new
      @db = nil
    end

    def bootstrap!
      setup_database
      require_app
      require_routes
    end

    def routes(&block)
      @router.instance_eval(&block)
    end

    def call(env)
      route = @router.route_for(env)

      if route
        controller = route.controller.new(env)
        action     = route.action

        controller.params.merge!(route.params)

        make_response(controller, action)
      else
        route_not_found(env)
      end
    end

    private

    def require_app
      Dir["#{Simpler.root}/app/**/*.rb"].each { |file| require file }
    end

    def require_routes
      require Simpler.root.join('config/routes')
    end

    def setup_database
      database_config = YAML.load_file(Simpler.root.join('config/database.yml'))
      database_config['database'] = Simpler.root.join(database_config['database'])
      @db = Sequel.connect(database_config)
    end

    def make_response(controller, action)
      controller.make_response(action)
    end

    def route_not_found(env)
      path    = env['PATH_INFO']
      message = "Error 404: route '#{path}' not found\n"

      [404, { 'Content-Type' => 'text/plain' }, [message]]
    end

  end
end
