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
    status, headers, body = @app.call(env)

    entry!(env, status, headers)

    [status, headers, body]
  end

  private

  def entry!(env, status, headers)
    @logger.formatter = proc do |severity, datetime, progname, msg|
      "\n#{msg}"
    end

    entry = message(env, status, headers)

    @logger.info(entry)
  end

  def message(env, status, headers)
    time         = env['simpler.start_time']
    method       = env['REQUEST_METHOD']
    path         = env['PATH_INFO']
    controller   = env['simpler.controller'] ? env['simpler.controller'].class.name + '#' : '-'
    action       = env['simpler.action']
    params       = env['simpler.controller'] ? env['simpler.controller'].params : '-'
    # status     = status
    description  = STATUS_CODES[status]
    content_type = headers['Content-Type']
    template     = env['simpler.template_path']
    runtime      = env['simpler.runtime']

    # Start at: 2021-06-19 21:33:45
    # Request:  GET /tests/1
    # Handler:  TestsController#show
    # Params:   {"id" => "1"}
    # Response: 200 OK [text/html] tests/list.html.erb
    # Runtime:  0.007s
    <<~ENTRY
      Start at: #{time}
      Request:  #{method} #{path}
      Handler:  #{controller}#{action}
      Params:   #{params}
      Response: #{status} #{description} [#{content_type}] #{template}
      Runtime:  #{runtime}s
    ENTRY
  end
end
