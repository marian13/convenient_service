# frozen_string_literal: true

module ConvenientService
  module Support
    class Version
      class NullVersion
        ##
        # @param other [Object] Can be any type.
        # @return [nil]
        #
        def <(other)
          nil
        end

        ##
        # @param other [Object] Can be any type.
        # @return [nil]
        #
        def <=(other)
          nil
        end

        ##
        # @param other [Object] Can be any type.
        # @return [nil]
        #
        def ==(other)
          nil
        end

        ##
        # @param other [Object] Can be any type.
        # @return [nil]
        #
        def >(other)
          nil
        end

        ##
        # @param other [Object] Can be any type.
        # @return [nil]
        #
        def >=(other)
          nil
        end
      end
    end
  end
end
