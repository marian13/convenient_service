# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Concern
          include Support::Concern

          class_methods do
            ##
            # @api public
            # @return [ConvenientService::Support::UniqueValue]
            #
            def block
              Support::BLOCK
            end

            ##
            # @api public
            #
            # @see https://userdocs.convenientservice.org/basics/step_to_result_translation_table
            # @see https://userdocs.convenientservice.org/comprehensive_docs/docs/the_what/what_is_a_step_raw_input.html
            #
            # @param value [Object] Can be any type.
            # @return [ConvenientService::Support::RawValue]
            #
            def raw(value)
              Support::RawValue.wrap(value)
            end

            ##
            # @api private
            #
            # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
            #
            def step_class
              @step_class ||= Common::Plugins::CanHaveUserProvidedEntity.find_or_create_entity(self, Entities::Step)
            end
          end
        end
      end
    end
  end
end
