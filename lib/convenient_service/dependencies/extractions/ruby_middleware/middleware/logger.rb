##
# @author Ruby Middleware Team <https://github.com/Ibsciss/ruby-middleware>
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
# @see https://github.com/Ibsciss/ruby-middleware
##

module ConvenientService
  module Dependencies
    module Extractions
      module RubyMiddleware
        ##
        # @internal
        #   NOTE:
        #     Copied from `Ibsciss/ruby-middleware` without any logic modification.
        #     Version: v0.4.2.
        #     - Wrapped in a namespace `ConvenientService::Dependencies::Extractions::RubyMiddleware`.
        #     - Removed `require 'logger'` and `require 'pp'`.
        #
        #   - https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware/logger.rb
        #
        module Middleware

          class Logger
            def initialize app, logger, name = nil
              @app = app
              @write_to = logger
              @middleware_name = name
            end

            def call env
              write(
                  way_in_message(
                      next_middleware_name, env
              ))

              time = Time.now

              @app.call(env).tap { |env|
                write(
                    way_out_message(
                        next_middleware_name, (Time.now - time) * 1000.0, env
                ))
              }
            end

            def next_middleware_name
              @app.class.name
            end

            def pretty_print item
              ->(out){ PP.pp(item, out) }.('')
            end

            def way_in_message name, env
              ' %s has been called with: %s' % [name, pretty_print(env)]
            end

            def way_out_message name, time, value
              ' %s finished in %.0f ms and returned: %s' % [name, time, pretty_print(value)]
            end

            def write msg
              @write_to.add(::Logger::INFO, msg.slice(0, 255).strip!, @middleware_name)
            end
          end
        end
      end
    end
  end
end
