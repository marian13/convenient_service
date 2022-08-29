# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module HaveAliasMethod
        def have_alias_method(*args)
          Custom::HaveAliasMethod.new(*args)
        end
      end
    end
  end
end
