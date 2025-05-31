# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module HasAmazingPrintInspect
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [String]
                    #
                    def inspect
                      metadata = {ConvenientService: {}}

                      metadata[:ConvenientService][:entity] = "Result"
                      metadata[:ConvenientService][:service] = Utils::Class.display_name(service.class)
                      metadata[:ConvenientService][:original_service] = Utils::Class.display_name(original_service.class) if service != original_service
                      metadata[:ConvenientService][:status] = status.to_sym

                      metadata[:ConvenientService][:data_keys] = unsafe_data.keys if unsafe_data.keys.any?

                      ##
                      # TODO: Specs.
                      # TODO: Same for `amazing_print`.
                      #
                      if Utils.safe_send(self, :from_unhandled_exception?)
                        metadata[:ConvenientService][:message] = unhandled_exception.message.to_s
                        metadata[:ConvenientService][:backtrace] = unhandled_exception.backtrace.to_a.take(10) + ["..."]
                      else
                        metadata[:ConvenientService][:message] = unsafe_message.to_s unless unsafe_message.empty?
                      end

                      metadata.ai
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
