# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultShortSyntax
        module Error
          module Commands
            class AssertArgsCountLowerThanThree < Support::Command
              attr_reader :args

              def initialize(args:)
                @args = args
              end

              def call
                raise Errors::MoreThanTwoArgsArePassed.new if args.size > 2
              end
            end
          end
        end
      end
    end
  end
end
