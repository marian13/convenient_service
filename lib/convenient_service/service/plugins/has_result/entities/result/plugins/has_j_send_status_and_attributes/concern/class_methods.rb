# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module HasJSendStatusAndAttributes
                module Concern
                  module ClassMethods
                    ##
                    # @api private
                    # @param value [Object] Can be any type.
                    # @param result [ConvenientService::Service::Plugins::HasResult::Entities::Result].
                    # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code]
                    # @raise [ConvenientService::Support::Castable::Errors::FailedToCast]
                    #
                    # @internal
                    #   IMPORTANT: Skipping `result` is allowed only for tests.
                    #
                    def code(value:, result: create_without_initialize)
                      code_class.cast!(value).copy(overrides: {kwargs: {result: result}})
                    end

                    ##
                    # @api private
                    # @param value [Object] Can be any type.
                    # @param result [ConvenientService::Service::Plugins::HasResult::Entities::Result].
                    # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data]
                    # @raise [ConvenientService::Support::Castable::Errors::FailedToCast]
                    #
                    # @internal
                    #   IMPORTANT: Skipping `result` is allowed only for tests.
                    #
                    def data(value:, result: create_without_initialize)
                      data_class.cast!(value).copy(overrides: {kwargs: {result: result}})
                    end

                    ##
                    # @api private
                    # @param value [Object] Can be any type.
                    # @param result [ConvenientService::Service::Plugins::HasResult::Entities::Result].
                    # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message]
                    # @raise [ConvenientService::Support::Castable::Errors::FailedToCast]
                    #
                    # @internal
                    #   IMPORTANT: Skipping `result` is allowed only for tests.
                    #
                    def message(value:, result: create_without_initialize)
                      message_class.cast!(value).copy(overrides: {kwargs: {result: result}})
                    end

                    ##
                    # @api private
                    # @param value [Object] Can be any type.
                    # @param result [ConvenientService::Service::Plugins::HasResult::Entities::Result].
                    # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status]
                    # @raise [ConvenientService::Support::Castable::Errors::FailedToCast]
                    #
                    # @internal
                    #   IMPORTANT: Skipping `result` is allowed only for tests.
                    #
                    def status(value:, result: create_without_initialize)
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
