require 'pathname'
require_relative 'simpler/application'

module Simpler
  VERSION = '0.1.0'.freeze

  class << self
    def application
      Application.instance
    end

    def root
      Pathname.new(File.expand_path('..', __dir__))
    end
  end

end
