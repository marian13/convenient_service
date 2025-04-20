# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Examples
    module Standard
      class RequestParams
        module Services
          class LogRequestParams
            include ConvenientService::Standard::Config

            attr_reader :request, :params, :tag

            def initialize(request:, params:, tag: Constants::Tags::EMPTY)
              @request = request
              @params = params
              @tag = tag
            end

            def result
              Entities::Logger.log(message)

              success
            end

            private

            def message
              <<~MESSAGE
                #{prefix}:
                {
                #{content}
                }
              MESSAGE
            end

            def prefix
              text = "[Thread##{Thread.current.object_id}]"

              text += " [Request##{request.object_id}]"
              text += " [Params]"
              text += " [#{tag}]" unless tag.empty?

              text
            end

            def content
              params.map { |key, value| "  #{key}: #{value.inspect}" }.join(",\n")
            end
          end
        end
      end
    end
  end
end
