# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Feature
    module Plugins
      module CanHaveEntries
        module Exceptions
          class NotDefinedEntryMethod < ::ConvenientService::Exception
            def initialize_with_kwargs(name:, feature:)
              message = <<~TEXT
                Entry for `#{name}` is registered inside `#{feature.class}` feature, but its corresponding method is NOT defined.

                Did you forget to define it? For example, using method form:

                class #{feature.class}
                  entry :#{name}

                  # ...

                  def #{name}(...)
                    # ...
                  end

                  # ...
                end

                Or using block form:

                class #{feature.class}
                  entry :#{name} do |*args, **kwargs, &block|
                    # ...
                  end

                  # ...
                end
              TEXT

              initialize(message)
            end
          end
        end
      end
    end
  end
end
