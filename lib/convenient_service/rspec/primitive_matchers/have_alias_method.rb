# frozen_string_literal: true

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module HaveAliasMethod
        def have_alias_method(...)
          Classes::HaveAliasMethod.new(...)
        end
      end
    end
  end
end
