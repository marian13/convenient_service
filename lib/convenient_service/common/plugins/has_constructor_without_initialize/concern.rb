# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasConstructorWithoutInitialize
        module Concern
          include Support::Concern

          class_methods do
            ##
            # @return [Object]
            # @since 0.2.0
            #
            # @internal
            #   - https://ruby-doc.org/core-2.5.0/Class.html#method-i-allocate
            #   - https://frontdeveloper.pl/2018/11/ruby-allocate-method/
            #
            def create_without_initialize
              allocate
            end
          end
        end
      end
    end
  end
end
