class TestsController < Simpler::Controller

  def index
    @time = Time.now.strftime('%H:%M:%S')
    status 200
    render plain: "Hello! Current time: #{@time}"
  end

  def create

  end

  def show
    headers['X-Controller-Params'] = "#{params}"
    render :list, status: 200
  end

end
