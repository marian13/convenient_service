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

                    class ReturnValueChainingIsAlreadySet < ::ConvenientService::Exception
                      def initialize_without_arguments
                        message = <<~TEXT
                          Returns value chaining is already set.

                          Did you use `and_return_its_value` or `and_return { |delegation_value| ... }` multiple times? Or a combination of them?
                        TEXT

                        initialize(message)
                      end
                    end

                    class ComparingByChainingIsAlreadySet < ::ConvenientService::Exception
                      def initialize_without_arguments
                        message = <<~TEXT
                          Comparing by chaining is already set.

                          Did you use `comparing_by` multiple times?
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
