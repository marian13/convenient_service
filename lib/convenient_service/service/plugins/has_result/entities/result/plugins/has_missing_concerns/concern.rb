# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module HasMissingConcerns
                module Concern
                  include Support::Concern

                  instance_methods do
                    include Support::Dependency

                    dependency :recalculate, from: Result::Plugins::CanRecalculateResult::Concern

                    dependency :[], from: Result::Plugins::HasResultShortSyntax::Concern
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
