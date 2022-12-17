# frozen_string_literal: true

module ConvenientService
  module Support
    class Version
      class NullVersion
        ##
        # @return [nil]
        #
        def gem_version
          nil
        end

        ##
        # @param other [Object] Can be any type.
        # @return [nil]
        #
        def <=>(other)
          nil
        end

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

        ##
        # @return [String]
        #
        def to_s
          ""
        end
      end
    end
  end
end
