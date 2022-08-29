# frozen_string_literal: true

module ConvenientService
  module Support
    module Dependency
      module Commands
        class GetPrintableReceiver < Support::Command
          CONCERN = Support::PatternMatching.unique_value("concern")
          NOT_CONCERN = Support::PatternMatching.unique_value("not concern")

          ANYTHING = Support::PatternMatching.anything

          ##
          # TODO: Replace by native pattern matching when support for Rubies lower than 2.7 is dropped.
          #
          PATTERN = Support::PatternMatching.compile_pattern({
            ##
            # NOTE: | Object type | Receiver type | Concern/not concern |
            #
            ["instance", "module", ANYTHING] => ->(receiver) { "to include(prepend) `#{receiver}'" },
            ["class", "module", CONCERN] => ->(receiver) { "to include(prepend) `#{receiver}'" },
            ["class", "module", NOT_CONCERN] => ->(receiver) { "to extend(singleton_class.prepend) `#{receiver}'" },
            [ANYTHING, "class", ANYTHING] => ->(receiver) { "to inherit `#{receiver}'" }
          })

          attr_reader :receiver, :object

          def initialize(receiver:, object:)
            @receiver = receiver
            @object = object
          end

          def call
            ##
            # NOTE: Always something is matched. See `object_type' and `receiver_type' for details.
            #
            matched = PATTERN.match_first(object_type, receiver_type, concern_type)

            matched.call(receiver)
          end

          private

          ##
          # NOTE: Returns only `class' or `instance' since `object' is taken from `method_missing'.
          #
          def object_type
            @object_type ||= Utils::Object.resolve_type(object)
          end

          ##
          # NOTE: Returns only `class' or `module' since `receiver' fails validation then it is `instance'.
          #
          def receiver_type
            @receiver_type ||= Utils::Object.resolve_type(receiver)
          end

          def concern_type
            @concern_type ||= receiver_type == "module" && receiver.included_modules.include?(Support::Concern) ? CONCERN : NOT_CONCERN
          end
        end
      end
    end
  end
end
