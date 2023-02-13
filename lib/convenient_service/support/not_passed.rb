# frozen_string_literal: true

module ConvenientService
  module Support
    NOT_PASSED = ::Object.new.tap do |object|
      object.define_singleton_method(:inspect) { "not_passed" }
    end
  end
end
