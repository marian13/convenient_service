# frozen_string_literal: true

require_relative "request_params/constants"
require_relative "request_params/entities"
require_relative "request_params/services"
require_relative "request_params/utils"

##
# @since 0.3.0
#
# @internal
#   Usage example:
#
#     http_string =
#       <<~TEXT
#         POST /rules/1000000.json HTTP/1.1
#         User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36
#         Host: code-review.com
#         Content-Type: application/json; charset=utf-8
#         Content-Length: 134
#         Accept-Language: en-us
#         Accept-Encoding: gzip, deflate
#         Connection: Keep-Alive
#
#         {"title":"Avoid error shadowing","description":"Check the official User Docs","tags":["error-shadowing"]}
#       TEXT
#
#     request = ConvenientService::Examples::Standard::RequestParams::Entities::Request.new(http_string:)
#
#     ConvenientService::Examples::Standard::RequestParams.prepare(request)
#
#   - https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types
#   - https://www.whatismybrowser.com/guides/the-latest-user-agent/chrome
#   - https://www.tutorialspoint.com/http/http_requests.htm
#
module ConvenientService
  module Examples
    module Standard
      class RequestParams
        include ConvenientService::Feature::Standard::Config

        entry :prepare

        def prepare(request)
          Services::Prepare[request: request]
        end
      end
    end
  end
end
