# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "key_modes/base"
require_relative "key_modes/none"
require_relative "key_modes/one"
require_relative "key_modes/many"

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module CanBeUsedInServiceAwareEnumerables
                module Entities
                  module KeyModes
                    class << self
                      ##
                      # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Entities::KeyModes::None]
                      #
                      def none
                        @none ||= Entities::KeyModes::None.new
                      end

                      ##
                      # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Entities::KeyModes::One]
                      #
                      def one
                        @one ||= Entities::KeyModes::One.new
                      end

                      ##
                      # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Entities::KeyModes::Many]
                      #
                      def many
                        @many ||= Entities::KeyModes::Many.new
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
