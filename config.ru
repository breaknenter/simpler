require_relative 'config/environment'

use Rack::Reloader

use Log, log: File.expand_path('log/app.log', __dir__)
use Runtime

run Simpler.application

# $ rackup
# $ curl --url "http://localhost:9292" -i
