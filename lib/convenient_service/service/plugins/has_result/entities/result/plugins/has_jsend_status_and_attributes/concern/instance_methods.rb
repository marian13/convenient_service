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
                      :success?,
                      :failure?,
                      :error?,
                      :not_success?,
                      :not_failure?,
                      :not_error?,
                      to: :status

                    def service
                      internals.cache[:jsend_attributes].service
                    end

                    def status
                      internals.cache[:jsend_attributes].status
                    end

                    def data
                      internals.cache[:jsend_attributes].data
                    end

                    def message
                      internals.cache[:jsend_attributes].message
                    end

                    def code
                      internals.cache[:jsend_attributes].code
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
