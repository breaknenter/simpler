class TestsController < Simpler::Controller

  def index
    # time = Time.now.strftime('%H:%M:%S')
    # render plain: "Hello! Current time: #{@time}"

    @tests = Test.all

    render :list, status: 200
  end

  def create

  end

  def show
    headers['X-Controller-Params'] = params['id']

    test = Test[params['id']]

    status 200

    render plain: "Test: #{test.title} (#{test.level})"
  end

end
