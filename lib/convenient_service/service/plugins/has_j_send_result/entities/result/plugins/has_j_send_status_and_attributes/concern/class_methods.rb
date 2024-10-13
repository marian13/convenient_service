# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module HasJSendStatusAndAttributes
                module Concern
                  module ClassMethods
                    ##
                    # @api private
                    # @return [Class]
                    #
                    # @internal
                    #   NOTE: A command instead of `import` is used in order to NOT pollute the public interface.
                    #   TODO: Specs that prevent public interface accidental pollution.
                    #
                    def code_class
                      @code_class ||= Commands::CreateCodeClass.call(result_class: self)
                    end

                    ##
                    # @api private
                    # @return [Class]
                    #
                    # @internal
                    #   NOTE: A command instead of `import` is used in order to NOT pollute the public interface.
                    #   TODO: Specs that prevent public interface accidental pollution.
                    #
                    def data_class
                      @data_class ||= Commands::CreateDataClass.call(result_class: self)
                    end

                    ##
                    # @api private
                    # @return [Class]
                    #
                    # @internal
                    #   NOTE: A command instead of `import` is used in order to NOT pollute the public interface.
                    #   TODO: Specs that prevent public interface accidental pollution.
                    #
                    def message_class
                      @message_class ||= Commands::CreateMessageClass.call(result_class: self)
                    end

                    ##
                    # @api private
                    # @return [Class]
                    #
                    # @internal
                    #   NOTE: A command instead of `import` is used in order to NOT pollute the public interface.
                    #   TODO: Specs that prevent public interface accidental pollution.
                    #
                    def status_class
                      @status_class ||= Commands::CreateStatusClass.call(result_class: self)
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
