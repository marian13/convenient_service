# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Exceptions
          class ResultIsNotOverridden < ::ConvenientService::Exception
            def initialize_with_kwargs(service:)
              message = <<~TEXT
                Result method (#result) of `#{Utils::Class.display_name(service.class)}` is NOT overridden.
              TEXT

              initialize(message)
            end
          end
        end
      end
    end
  end
end
