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
              module CanBeUsedInServiceAwareEnumerables
                module Exceptions
                  class NotExistingAttributeForOnly < ::ConvenientService::Exception
                    ##
                    # @param key [Symbol]
                    # @return [void]
                    #
                    def initialize_with_kwargs(key:)
                      message = <<~TEXT
                        Data attribute by key `:#{key}` does NOT exist. That is why it can NOT be selected. Make sure the corresponding result has it.
                      TEXT

                      initialize(message)
                    end
                  end

                  class NotExistingAttributeForExcept < ::ConvenientService::Exception
                    ##
                    # @param key [Symbol]
                    # @return [void]
                    #
                    def initialize_with_kwargs(key:)
                      message = <<~TEXT
                        Data attribute by key `:#{key}` does NOT exist. That is why it can NOT be dropped. Make sure the corresponding result has it.
                      TEXT

                      initialize(message)
                    end
                  end

                  class NotExistingAttributeForRename < ::ConvenientService::Exception
                    ##
                    # @param key [Symbol]
                    # @return [void]
                    #
                    def initialize_with_kwargs(key:, renamed_key:)
                      message = <<~TEXT
                        Data attribute by key `:#{key}` does NOT exist. That is why it can NOT be renamed to `:#{renamed_key}`. Make sure the corresponding result has it.
                      TEXT

                      initialize(message)
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
