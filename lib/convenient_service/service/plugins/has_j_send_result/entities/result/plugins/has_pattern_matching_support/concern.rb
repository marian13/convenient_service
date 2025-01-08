# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module HasPatternMatchingSupport
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @api public
                    # @return [Array]
                    # @note https://zverok.space/blog/2022-12-20-pattern-matching.html
                    # @note https://ruby-doc.org/core-2.7.2/doc/syntax/pattern_matching_rdoc.html
                    # @note Expected to be called only from pattern matching. Avoid direct usage of this method.
                    #
                    def deconstruct
                      case status.to_sym
                      when :success
                        [status.to_sym, unsafe_data.to_h]
                      when :failure
                        [status.to_sym, unsafe_message.to_s]
                      when :error
                        [status.to_sym, unsafe_message.to_s]
                      end
                    end

                    ##
                    # @api public
                    # @param keys [Array<Symbol>, nil]
                    # @return [Hash]
                    # @note https://zverok.space/blog/2022-12-20-pattern-matching.html
                    # @note https://ruby-doc.org/core-2.7.2/doc/syntax/pattern_matching_rdoc.html
                    # @note Expected to be called only from pattern matching. Avoid direct usage of this method.
                    #
                    def deconstruct_keys(keys)
                      keys ||= [:status, :data, :message, :code, :step, :step_index, :service, :original_service]

                      keys.each_with_object({}) do |key, hash|
                        case key
                        when :status
                          hash[key] = status.to_sym
                        when :data
                          hash[key] = unsafe_data.to_h
                        when :message
                          hash[key] = unsafe_message.to_s
                        when :code
                          hash[key] = unsafe_code.to_sym
                        when :step
                          hash[key] =
                            if step
                              step.service_step? ? step.service_result.service : step.action
                            end
                        when :step_index
                          hash[key] = step&.index
                        when :service
                          hash[key] = service
                        when :original_service
                          hash[key] = original_service
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
