# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasConfig
        module Entities
          ##
          # TODO: Specs. Currently checked by `ClassMethods`.
          #
          class ReadOnlyConfig < Entities::Config
            def method_missing(method, value = nil)
              return super if method.end_with?("=")

              key = method.to_s

              define_singleton_method(method) { @hash[key] }

              __send__(method)
            end

            ##
            # TODO: Implement.
            # https://thoughtbot.com/blog/always-define-respond-to-missing-when-overriding
            #
            def respond_to_missing?(method_name, include_private = false)
              false
            end
          end
        end
      end
    end
  end
end
