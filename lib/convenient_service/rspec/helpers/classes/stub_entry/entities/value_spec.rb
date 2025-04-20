# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module Helpers
      module Classes
        ##
        # @internal
        #   TODO: Specs.
        #
        class StubEntry < Support::Command
          module Entities
            class ValueSpec
              ##
              # @param value [Object] Can be any type.
              # @param feature_class [Class]
              # @return [void]
              #
              def initialize(value:, feature_class: nil)
                @value = value
                @feature_class = feature_class
              end

              ##
              # @param feature_class [Class]
              # @return [ConvenientService::RSpec::Helpers::Classes::StubEntry::Entities::ValueSpec]
              #
              def for(feature_class)
                self.class.new(value: value, feature_class: feature_class)
              end

              ##
              # @return [Object]
              #
              # @internal
              #    TODO: Assert.
              #
              def calculate_value
                value
              end

              ##
              # @param other [Object] Can be any type.
              # @return [Boolean, nil]
              #
              def ==(other)
                return unless other.instance_of?(self.class)

                return false if value != other.value
                return false if feature_class != other.feature_class

                true
              end

              protected

              ##
              # @!attribute [r] value
              #   @return [Object] Can be any type.
              #
              attr_reader :value

              ##
              # @!attribute [r] feature_class
              #   @return [Class]
              #
              attr_reader :feature_class
            end
          end
        end
      end
    end
  end
end
