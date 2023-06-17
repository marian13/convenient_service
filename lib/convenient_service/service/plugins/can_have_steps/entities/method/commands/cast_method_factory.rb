# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Method
            module Commands
              class CastMethodFactory < Support::Command
                ##
                # @!attribute [r] options
                #   @return [Object] Can be any type.
                #
                attr_reader :other

                ##
                # @param other [Object] Can be any type.
                #
                def initialize(other:)
                  @other = other
                end

                ##
                # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Factries::Base, nil]
                #
                def call
                  return unless factory_class

                  factory_class.new(**factory_kwargs)
                end

                private

                ##
                # @return [Class, nil]
                #
                def factory_class
                  Utils.memoize_including_falsy_values(self, :@factory_class) do
                    case other
                    when ::Symbol then cast_symbol
                    when ::String then cast_string
                    when ::Hash then cast_hash
                    when Entities::Values::Reassignment then cast_reassignment
                    when Method then cast_method
                    end
                  end
                end

                ##
                # @return [Hash]
                #
                def factory_kwargs
                  {other: other}
                end

                ##
                # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Factries::Base, nil]
                #
                def cast_symbol
                  Entities::Factories::Symbol
                end

                ##
                # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Factries::Base, nil]
                #
                def cast_string
                  Entities::Factories::String
                end

                ##
                # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Factries::Base, nil]
                #
                def cast_reassignment
                  Entities::Factories::Reassignment
                end

                ##
                # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Factries::Base, nil]
                #
                def cast_hash
                  return unless other.keys.one?

                  value = other.values.first

                  case value
                  when ::Symbol
                    Entities::Factories::Hash::SymbolValue
                  when ::String
                    Entities::Factories::Hash::StringValue
                  when ::Proc
                    Entities::Factories::Hash::ProcValue
                  when Support::RawValue
                    Entities::Factories::Hash::RawValue
                  when Entities::Values::Reassignment
                    Entities::Factories::Hash::ReassignmentValue
                  end
                end

                ##
                # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Factries::Base, nil]
                #
                def cast_method
                  Entities::Factories::Method
                end
              end
            end
          end
        end
      end
    end
  end
end
