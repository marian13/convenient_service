# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
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
                                  result: result.class.name,
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
