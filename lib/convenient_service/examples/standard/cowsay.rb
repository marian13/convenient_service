# frozen_string_literal: true

require_relative "cowsay/services"

##
# @internal
#   Usage examples:
#
#   result = ConvenientService::Examples::Standard::Cowsay.print("Hello")
#   result = ConvenientService::Examples::Standard::Cowsay.print("Hi")
#
module ConvenientService
  module Examples
    module Standard
      class Cowsay
        include ConvenientService::Feature::Standard::Config

        entry :print

        def print(text = "Hello World!", out: $stdout)
          Services::Print[text: text, out: out]
        end
      end
    end
  end
end
