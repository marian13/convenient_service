# frozen_string_literal: true

module ConvenientService
  module Support
    class RawValue
      ##
      # @param object [Object] Can be any type.
      # @return [void]
      #
      def initialize(object)
        @object = object
      end

      class << self
        ##
        # @param object [Object] Can be any type.
        # @return [ConvenientService::Support::RawValue]
        #
        def wrap(object)
          new(object)
        end

        private :new
      end

      ##
      # @return [Object] Can be any type.
      #
      def unwrap
        object
      end

      ##
      # @return [Boolean, nil]
      #
      def ==(other)
        return unless other.instance_of?(self.class)

        return false if object != other.object

        true
      end

      protected

      ##
      # @return [Object] Can be any type.
      #
      attr_reader :object
    end
  end
end
