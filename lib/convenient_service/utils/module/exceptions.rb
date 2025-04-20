# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Utils
    module Module
      module Exceptions
        class NestingUnderAnonymousNamespace < ::ConvenientService::Exception
          def initialize_with_kwargs(mod:, namespace:)
            message = <<~TEXT
              `#{mod}` is nested under anonymous namespace `#{namespace}`.

              Unfortunately, Ruby does NOT have a reliable way to get corresponding `Module` or `Class` object by anonymous namespace name.
              - https://bugs.ruby-lang.org/issues/15408
              - https://stackoverflow.com/questions/2818602/in-ruby-why-does-inspect-print-out-some-kind-of-object-id-which-is-different
            TEXT

            initialize(message)
          end
        end
      end
    end
  end
end
