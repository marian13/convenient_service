# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Method
            module Concern
              module InstanceMethods
                include Support::Delegate

                ##
                # @!attribute [r] key
                #   @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Key]
                #
                attr_reader :key

                ##
                # @!attribute [r] name
                #   @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Name]
                #
                attr_reader :name

                ##
                # @!attribute [r] caller
                #   @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Callers::Base]
                #
                attr_reader :caller

                ##
                # @!attribute [r] direction
                #   @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Directions::Base]
                #
                attr_reader :direction

                ##
                # @return [Boolean]
                #
                delegate :usual?, to: :caller

                ##
                # @return [Boolean]
                #
                delegate :alias?, to: :caller

                ##
                # @return [Boolean]
                #
                delegate :proc?, to: :caller

                ##
                # @return [Boolean]
                #
                delegate :raw?, to: :caller

                ##
                # @return [String]
                #
                delegate :to_s, to: :name

                ##
                # @param key [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Key]
                # @param name [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Name]
                # @param caller [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Callers::Base]
                # @param direction [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Directions::Base]
                # @param organizer [ConvenientService::Service, nil]
                # @return [void]
                #
                def initialize(key:, name:, caller:, direction:, organizer: nil)
                  @key = key
                  @name = name
                  @caller = caller
                  @direction = direction
                  @organizer = organizer
                end

                ##
                # @param raise_when_missing [Boolean]
                # @return [ConvenientService::Service, nil]
                # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::MethodHasNoOrganizer]
                #
                def organizer(raise_when_missing: true)
                  ::ConvenientService.raise Exceptions::MethodHasNoOrganizer.new(method: self) if @organizer.nil? && raise_when_missing

                  @organizer
                end

                ##
                # @return [Object] Can be any type.
                #
                def value
                  @value ||= caller.calculate_value(self)
                end

                ##
                # @return [Boolean]
                #
                def has_organizer?
                  Utils.to_bool(organizer(raise_when_missing: false))
                end

                ##
                # @param container [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service]
                # @param index [Integer]
                # @return [Boolean] true if method is just defined, false if already defined.
                #
                # @internal
                #   TODO: Split input and output methods into separate classes.
                #
                def define_output_in_container!(container, index:)
                  direction.define_output_in_container!(container, index: index, method: self)

                  caller.define_output_in_container!(container, index: index, method: self)
                end

                ##
                # @param other [Object] Can be any object.
                # @return [Boolean, nil]
                #
                def ==(other)
                  return unless other.instance_of?(self.class)

                  return false if key != other.key
                  return false if name != other.name
                  return false if caller != other.caller
                  return false if direction != other.direction
                  return false if organizer(raise_when_missing: false) != other.organizer(raise_when_missing: false)

                  true
                end

                ##
                # @return [Hash{Symbol => Object}]
                #
                def to_kwargs
                  to_arguments.kwargs
                end

                ##
                # @return [ConvenientService::Support::Arguments]
                #
                def to_arguments
                  Support::Arguments.new(
                    key: key,
                    name: name,
                    caller: caller,
                    direction: direction,
                    organizer: organizer(raise_when_missing: false)
                  )
                end
              end
            end
          end
        end
      end
    end
  end
end
