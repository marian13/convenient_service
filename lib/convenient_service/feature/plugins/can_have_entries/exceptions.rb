# frozen_string_literal: true

module ConvenientService
  module Feature
    module Plugins
      module CanHaveEntries
        module Exceptions
          class NotDefinedEntryMethod < ::ConvenientService::Exception
            def initialize(name:, feature:)
              message = <<~TEXT
                Entry for `#{name}` is registered inside `#{feature.class}` feature, but its corresponding method is NOT defined.

                Did you forget to define it? For example:

                class #{feature.class}
                  entry :#{name}

                  # ...

                  def #{name}
                    # ...
                  end

                  # ...
                end
              TEXT

              super(message)
            end
          end
        end
      end
    end
  end
end
