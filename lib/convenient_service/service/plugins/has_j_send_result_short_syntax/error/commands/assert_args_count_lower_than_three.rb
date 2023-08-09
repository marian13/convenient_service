# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResultShortSyntax
        module Error
          module Commands
            class AssertArgsCountLowerThanThree < Support::Command
              attr_reader :args

              def initialize(args:)
                @args = args
              end

              def call
                raise Exceptions::MoreThanTwoArgsArePassed.new if args.size > 2
              end
            end
          end
        end
      end
    end
  end
end
