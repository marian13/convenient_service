# frozen_string_literal: true

module ConvenientService
  module Support
    UNDEFINED = ::Object.new.tap do |object|
      object.define_singleton_method(:inspect) { "undefined" }
    end
  end
end
