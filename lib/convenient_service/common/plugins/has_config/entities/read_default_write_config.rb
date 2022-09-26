# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasConfig
        module Entities
          ##
          # TODO: Specs. Currently checked by `ClassMethods`.
          #
          class ReadDefaultWriteConfig < Entities::Config
            def method_missing(method, value = nil)
              key = method.to_s

              if method.end_with?("=")
                define_singleton_method(method) { |value| @hash.store(key.chomp("="), value) }

                __send__(method, value)
              else
                define_singleton_method(method) { @hash.fetch(key) { @hash.store(key, self.class.new) } }

                __send__(method)
              end
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
