require_relative 'config/environment'

use Rack::Reloader
use Runtime
use Log, log: File.expand_path('log/app.log', __dir__)

run Simpler.application
