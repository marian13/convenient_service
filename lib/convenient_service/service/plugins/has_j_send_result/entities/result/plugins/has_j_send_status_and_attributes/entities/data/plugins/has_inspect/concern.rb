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
                  class Data
                    module Plugins
                      module HasInspect
                        module Concern
                          include Support::Concern

                          instance_methods do
                            ##
                            # @return [String]
                            #
                            def inspect
                              return "<#{Utils::Class.display_name(result.service.class)}::Result::Data>" if empty?

                              values = to_h.map { |key, value| "#{key}: #{Utils::String.truncate(value.inspect, 15, omission: "...")}" }.join(", ")

                              "<#{Utils::Class.display_name(result.service.class)}::Result::Data #{values}>"
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
