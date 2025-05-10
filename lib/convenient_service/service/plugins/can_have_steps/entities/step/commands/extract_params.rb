# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Commands
              class ExtractParams < Support::Command
                ##
                # @!attribute [r] args
                #   @return [Array<Object>]
                #
                attr_reader :args

                ##
                # @!attribute [r] kwargs
                #   @return [Hash{Symbol => Object}]
                #
                attr_reader :kwargs

                ##
                # @param args [Array<Object>]
                # @param kwargs [Hash{Symbol => Object}]
                # @return [void]
                #
                def initialize(args:, kwargs:)
                  @args = args
                  @kwargs = kwargs
                end

                ##
                # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Params]
                #
                def call
                  Structs::Params.new(
                    action: args.first,
                    inputs: Utils::Array.wrap(kwargs[:in]),
                    outputs: Utils::Array.wrap(kwargs[:out]),
                    strict: kwargs[:strict],
                    index: kwargs[:index],
                    container: kwargs[:container],
                    organizer: kwargs[:organizer],
                    extra_kwargs: Utils::Hash.except(kwargs, [:in, :out, :index, :container, :organizer])
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
