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
                    # @param value [Object] Can be any type.
                    # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result].
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code]
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    # @internal
                    #   IMPORTANT: Skipping `result` is allowed only for tests.
                    #
                    def code(value:, result: new_without_initialize)
                      code_class.cast!(value).copy(overrides: {kwargs: {result: result}})
                    end

                    ##
                    # @api private
                    # @param value [Object] Can be any type.
                    # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result].
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data]
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    # @internal
                    #   IMPORTANT: Skipping `result` is allowed only for tests.
                    #
                    def data(value:, result: new_without_initialize)
                      data_class.cast!(value).copy(overrides: {kwargs: {result: result}})
                    end

                    ##
                    # @api private
                    # @param value [Object] Can be any type.
                    # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result].
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message]
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    # @internal
                    #   IMPORTANT: Skipping `result` is allowed only for tests.
                    #
                    def message(value:, result: new_without_initialize)
                      message_class.cast!(value).copy(overrides: {kwargs: {result: result}})
                    end

                    ##
                    # @api private
                    # @param value [Object] Can be any type.
                    # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result].
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status]
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    # @internal
                    #   IMPORTANT: Skipping `result` is allowed only for tests.
                    #
                    def status(value:, result: new_without_initialize)
                      status_class.cast!(value).copy(overrides: {kwargs: {result: result}})
                    end

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
