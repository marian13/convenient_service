# frozen_string_literal: true

##
# Usage example:
#
# result = ConvenientService::Examples::Dry::Gemfile.format(path: "Gemfile")
# result = ConvenientService::Examples::Dry::Gemfile.format(path: "spec/cli/gemfile/format/fixtures/Gemfile")
#
module ConvenientService
  module Examples
    module Dry
      module Gemfile
        class << self
          def format
            Services::Format[path: path]
          end
        end
      end
    end
  end
end
