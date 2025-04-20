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
              module HasJSendStatusAndAttributes
                module Entities
                  class Data
                    module Plugins
                      module HasAwesomePrintInspect
                        module Concern
                          include Support::Concern

                          instance_methods do
                            ##
                            # @return [String]
                            #
                            def inspect
                              metadata = {
                                ConvenientService: {
                                  entity: "Data",
                                  result: "#{Utils::Class.display_name(result.service.class)}::Result",
                                  values: to_h
                                }
                              }

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
      end
    end
  end
end
