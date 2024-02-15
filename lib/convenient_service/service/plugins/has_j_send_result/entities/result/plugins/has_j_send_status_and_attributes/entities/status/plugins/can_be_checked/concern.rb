# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module HasJSendStatusAndAttributes
                module Entities
                  class Status
                    module Plugins
                      module CanBeChecked
                        module Concern
                          include Support::Concern

                          instance_methods do
                            ##
                            # @return [Boolean]
                            #
                            def checked?
                              Utils.to_bool(internals.cache[:checked])
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
