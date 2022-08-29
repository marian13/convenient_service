# frozen_string_literal: true

module ConvenientService
  module Utils
    module Array
      class Wrap < Support::Command
        attr_reader :object

        def initialize(object)
          @object = object
        end

        ##
        # Copied without any modifications from:
        # https://api.rubyonrails.org/classes/Array.html#method-c-wrap
        #
        def call
          if object.nil?
            []
          elsif object.respond_to?(:to_ary)
            object.to_ary || [object]
          else
            [object]
          end
        end
      end
    end
  end
end
