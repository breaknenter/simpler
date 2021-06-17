require 'logger'

class Log
  STATUS_CODES = {
    # 2xx success
    200 => 'OK',

    # 4xx client errors
    404 => 'Not Found'
  }.freeze

  def initialize(app, **options)
    @app    = app
    @logger = Logger.new(options[:log] || STDOUT, 'daily')
  end

  def call(env)
    @request = Rack::Request.new(env)
    status, headers, body = @app.call(env)

    entry!(env, headers, status)
    
    [status, headers, body]
  end

  private

  def entry!(env, headers, status)
    @logger.formatter = proc do |severity, datetime, progname, msg|
      "#{datetime}\n#{msg}\n"
    end

    entry = message(env, headers, status)

    @logger.info(entry)
  end

  def message(env, headers, status)
    method       = @request.request_method
    path         = @request.fullpath
    controller   = env['simpler.controller'] ? env['simpler.controller'].name.capitalize + 'Controller' : nil
    action       = env['simpler.action']
    params       = @request.params
    # status     = status
    description  = STATUS_CODES[status]
    content_type = headers['Content-Type']
    template     = env['simpler.template_path']
    runtime      = env['simpler.runtime']

    # Request:  GET /tests?id=1
    # Handler:  TestsController#show
    # Params:   {"id" => "1"}
    # Response: 200 OK [text/html] tests/show.html.erb
    # Runtime:  0.007s
    <<~ENTRY
      Request:  #{method} #{path}
      Handler:  #{controller}##{action}
      Params:   #{params}
      Response: #{status} #{description} [#{content_type}] #{template}
      Runtime:  #{runtime}s
    ENTRY
  end
end
