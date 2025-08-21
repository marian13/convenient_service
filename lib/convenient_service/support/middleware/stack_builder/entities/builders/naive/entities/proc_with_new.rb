# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Support
    module Middleware
      class StackBuilder
        module Entities
          module Builders
            class Naive
              module Entities
                ##
                # @internal
                #   TODO: Static Builder.
                #
                class ProcWithNew
                  ##
                  # @!attribute [r] proc
                  #   @return [Proc]
                  #
                  attr_reader :proc

                  ##
                  # @param proc [Proc]
                  #
                  def initialize(proc)
                    @proc = proc
                  end

                  ##
                  # @param app [Object] Can any type.
                  # @return [Proc]
                  #
                  def new(app = nil)
                    self.proc
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
