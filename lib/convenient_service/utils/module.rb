# frozen_string_literal: true

require_relative "module/get_own_instance_method"
require_relative "module/get_own_const"
require_relative "module/has_own_instance_method"

module ConvenientService
  module Utils
    ##
    # @internal
    #   NOTE: `Class` is descendant of `Module`, that is why `Module` is more generic term.
    #   TODO: Better generic term for both `Module` and `Class`.
    #
    module Module
      class << self
        def get_own_instance_method(...)
          GetOwnInstanceMethod.call(...)
        end

        def get_own_const(...)
          GetOwnConst.call(...)
        end

        def has_own_instance_method?(...)
          HasOwnInstanceMethod.call(...)
        end
      end
    end
  end
end
