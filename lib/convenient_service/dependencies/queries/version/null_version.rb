# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Dependencies
    module Queries
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
          # @return [Boolean]
          #
          def null_version?
            true
          end

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
end
