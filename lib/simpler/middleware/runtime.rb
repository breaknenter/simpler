class Runtime
  def initialize(app)
    @app = app
  end

  def call(env)
    start_time = Time.now
    response = @app.call(env)

    env['simpler.runtime'] = '%.3f' % (Time.now - start_time)
    env['simpler.start_time'] = start_time.strftime('%F %T')

    response
  end
end
