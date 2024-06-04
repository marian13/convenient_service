# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CountsResultResolutionsInvocations
        module Concern
          include Support::Concern

          instance_methods do
            ##
            # @api private
            #
            # @return [ConvenientService::Support::Counter]
            #
            # @note Instance method `result_resolutions_counter` is NOT thread-safe. That is intentional.
            # @note If you require thread-safety, do NOT reuse same service instance between mutiple threads. Create new separate service instance for each of threads.
            #
            def result_resolutions_counter
              @result_resolutions_counter ||= Support::Counter.new
            end
          end
        end
      end
    end
  end
end
