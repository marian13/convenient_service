# frozen_string_literal: true

module ConvenientService
  module Support
    class Version
      ##
      # @api private
      #
      # @internal
      #   - https://thoughtbot.com/blog/rails-refactoring-example-introduce-null-object
      #   - https://avdi.codes/null-objects-and-falsiness/
      #
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
