# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# Reset `faker` seed before every spec to have deterministic results.
# - https://github.com/faker-ruby/faker#deterministic-random
#
# NOTE: `ffaker` is NOT currently used by `ConveninetService`, but its tutorials are very useful.
# - https://github.com/ffaker/ffaker/blob/main/RANDOM.md#rspec
#
RSpec.configure do |config|
  config.before do
    Faker::Config.random = Random.new(42)
  end
end
