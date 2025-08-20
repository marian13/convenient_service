# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "bundler/setup"

# require "convenient_service/dependencies/only_development_tools"
require "convenient_service"
require "stackprof"

class Service
  include ConvenientService::Standard::Config
end

Service.commit_config!

##
# Quotes:
# - stackprof will tell you what is impeding your progress.
# - The assumption is the more times something shows up in the sample the more time it is taking.
#
# Docs:
# - https://www.johnnunemaker.com/how-to-benchmark-your-ruby-gem
# - https://github.com/tmm1/stackprof
#
profile = StackProf.run(mode: :wall, interval: 1_000) do
  2_000_000.times { Service.has_committed_config? }
end

result = StackProf::Report.new(profile)
puts
result.print_text
puts "\n\n\n"
result.print_method(/has_committed_config?/)
