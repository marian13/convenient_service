# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveRSpecStubbedResults
        module Concern
          include Support::Concern

          class_methods do
            ##
            # @return [RSpec::Core::Example, nil]
            #
            # @internal
            #   NOTE: `::RSpec.current_example` docs.
            #   - https://www.rubydoc.info/github/rspec/rspec-core/RSpec.current_example
            #   - https://github.com/rspec/rspec-core/blob/v3.12.0/lib/rspec/core.rb#L122
            #   - https://github.com/rspec/rspec-support/blob/v3.12.0/lib/rspec/support.rb#L92
            #   - https://relishapp.com/rspec/rspec-core/docs/metadata/current-example
            #
            def stubbed_results_store
              Dependencies.rspec.current_example
            end
          end
        end
      end
    end
  end
end
