# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module V1
        class Factorial
          module Utils
            module Timeout
              class WithTimeout < ConvenientService::Command
                ReturnStruct = ::Struct.new(:timeout?, :value, keyword_init: true)

                attr_reader :seconds, :block

                def initialize(seconds, &block)
                  @seconds = seconds
                  @block = block
                end

                ##
                # @internal
                #   NOTE: Prefer to avoid `Timeout.timeout` if you are NOT absolutely 100% sure what you are doing. See the following articles for details.
                #   - https://github.com/ruby/timeout/blob/master/lib/timeout.rb
                #   - https://adamhooper.medium.com/in-ruby-dont-use-timeout-77d9d4e5a001
                #   - https://flushentitypacket.github.io/ruby/2015/02/21/ruby-timeout-how-does-it-even-work.html
                #   - https://www.exceptionalcreatures.com/bestiary/Timeout/Error
                #   - https://github.com/ankane/the-ultimate-guide-to-ruby-timeouts#regexp
                #
                def call
                  return struct(timeout?: false, value: block.call) if seconds.nil?
                  return struct(timeout?: true, value: nil) if seconds.zero?

                  begin
                    struct(timeout?: false, value: ::Timeout.timeout(seconds, &block))
                  rescue ::Timeout::Error
                    struct(timeout?: true, value: nil)
                  end
                end

                private

                def struct(**kwargs)
                  ReturnStruct.new(**kwargs)
                end
              end
            end
          end
        end
      end
    end
  end
end
