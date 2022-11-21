# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module HasJsendStatusAndAttributes
                module Concern
                  ##
                  # TODO: How to use concern outside?
                  #
                  module InstanceMethods
                    include Support::Delegate
                    include Support::Copyable

                    delegate \
                      :service,
                      :status,
                      :data,
                      :message,
                      :code,
                      to: :params

                    delegate \
                      :success?,
                      :failure?,
                      :error?,
                      :not_success?,
                      :not_failure?,
                      :not_error?,
                      to: :status

                    def initialize(**params)
                      @params = Commands::CastResultParams.call(params: params)
                    end

                    def ==(other)
                      return unless other.instance_of?(self.class)

                      return false if service.class != other.service.class
                      return false if status != other.status
                      return false if data != other.data
                      return false if message != other.message
                      return false if code != other.code

                      true
                    end

                    def to_kwargs
                      {service: service, status: status, data: data, message: message, code: code}
                    end

                    private

                    attr_reader :params
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
