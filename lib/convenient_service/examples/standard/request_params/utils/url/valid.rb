# frozen_string_literal: true

##
#
#
module ConvenientService
  module Examples
    module Standard
      class RequestParams
        module Utils
          module URL
            ##
            # TODO: Use to validate URLs.
            #
            class Valid < ConvenientService::Command
              attr_reader :url

              def initialize(url)
                @url = url
              end

              ##
              # NOTE: How to validate URLs?
              # - https://storck.io/posts/better-http-url-validation-in-ruby-on-rails
              # - https://github.com/sporkmonger/addressable/issues/1452
              #
              # NOTE: URL is NOT URI.
              # - https://stackoverflow.com/a/16359999/12201472
              # - https://stackoverflow.com/a/13041565/12201472
              #
              # NOTE: Why NOT to match `URI::regexp`?
              # - https://bugs.ruby-lang.org/issues/6520
              #
              def call
                uri = ::URI.parse(url.to_s)

                uri.is_a?(::URI::HTTPS) || uri.is_a?(::URI::HTTP)
              rescue ::URI::InvalidURIError
                false
              end
            end
          end
        end
      end
    end
  end
end
