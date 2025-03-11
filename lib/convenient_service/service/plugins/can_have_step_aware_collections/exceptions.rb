# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareCollections
        module Exceptions
          class CollectionIsNotEnumerable < ::ConvenientService::Exception
            def initialize_with_kwargs(collection:)
              message = <<~TEXT
                Collection `#{Utils::Class.display_name(collection.class)}` is NOT enumerable.

                Valid enumerable examples are classes that mix in `Enumerable` module like `Array`, `Hash`, `Set`, `Enumerator`, `Enumerator::Lazy`, etc.
              TEXT

              initialize(message)
            end
          end

          class AlreadyUsedTerminalChaining < ::ConvenientService::Exception
            def initialize_without_arguments
              message = <<~TEXT
                Collection already has a terminal chaining like `all?`, `any?`, `find`, `first`, etc.
              TEXT

              initialize(message)
            end
          end
        end
      end
    end
  end
end
