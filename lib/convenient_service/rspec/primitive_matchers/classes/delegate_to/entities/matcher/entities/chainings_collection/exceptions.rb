# frozen_string_literal: true

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module Classes
        class DelegateTo
          module Entities
            class Matcher
              module Entities
                class ChainingsCollection
                  module Exceptions
                    class CallOriginalChainingIsAlreadySet < ::ConvenientService::Exception
                      def initialize_without_arguments
                        message = <<~TEXT
                          Call original chaining is already set.

                          Did you use `with_calling_original` or `without_calling_original` multiple times? Or a combination of them?
                        TEXT

                        initialize(message)
                      end
                    end

                    class ArgumentsChainingIsAlreadySet < ::ConvenientService::Exception
                      def initialize_without_arguments
                        message = <<~TEXT
                          Arguments chaining is already set.

                          Did you use `with_arguments` or `without_arguments` multiple times? Or a combination of them?
                        TEXT

                        initialize(message)
                      end
                    end

                    class ReturnItsValueChainingIsAlreadySet < ::ConvenientService::Exception
                      def initialize_without_arguments
                        message = <<~TEXT
                          Returns its value chaining is already set.

                          Did you use `and_returns_its_value` multiple times?
                        TEXT

                        initialize(message)
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
