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
                  class Code
                    module Plugins
                      module HasInspect
                        module Concern
                          include Support::Concern

                          instance_methods do
                            ##
                            # @return [String]
                            #
                            def inspect
                              "<#{Utils::Class.display_name(result.service.class)}::Result::Code value: :#{value}>"
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
