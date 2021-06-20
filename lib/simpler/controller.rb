require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response, :headers

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @headers = {}
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    def params
      @request.params
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def set_headers
      @response.headers.merge!(@headers)
    end

    def write_response
      set_headers

      if @response['Content-Type'] == 'text/html'
        body = render_body

        @response.write(body)
      end
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def render(template = nil, **options)
      if template
        @request.env['simpler.template'] = template
      end

      options.each do |option, value|
        send("set_#{option}", value)
      end
    end

    def status(code)
      @response.status = code
    end

    alias_method :set_status, :status

    def set_plain(text)
      @response['Content-Type'] = 'text/plain'
      @response.write(text)
    end

  end
end
