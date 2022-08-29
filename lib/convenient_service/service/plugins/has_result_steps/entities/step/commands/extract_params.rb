# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultSteps
        module Entities
          class Step
            module Commands
              class ExtractParams < Support::Command
                attr_reader :args, :kwargs

                def initialize(args:, kwargs:)
                  @args = args
                  @kwargs = kwargs
                end

                def call
                  Structs::Params.new(
                    service: args.first,
                    inputs: Utils::Array.wrap(kwargs[:in]),
                    outputs: Utils::Array.wrap(kwargs[:out]),
                    index: kwargs[:index],
                    ##
                    # TODO: Specs.
                    #
                    container: kwargs[:container],
                    organizer: kwargs[:organizer]
                  )
                end
              end
            end
          end
        end
      end
    end
  end
end
