# frozen_string_literal: true

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module SingletonPrependModule
        def singleton_prepend_module(...)
          Classes::SingletonPrependModule.new(...)
        end
      end
    end
  end
end
