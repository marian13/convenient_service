# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveResultStep
        class Middleware < MethodChainMiddleware
          intended_for :step, scope: :class, entity: :service

          ##
          # @param args [Array<Object>]
          # @param kwargs [Hash{Symbol => Object}]
          # @param block [Proc, nil]
          # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
          #
          # @internal
          #   NOTE: It is okish to assign to next method arguments here,
          #   since splat for `args` and double splat for `kwargs`
          #   always create new arrays and hashes respectively.
          #   https://github.com/ruby/spec/blob/c7ed8478a031d0df346d222495f4b4bbb298523b/language/keyword_arguments_spec.rb#L100
          #
          def next(*args, **kwargs, &block)
            return chain.next(*args, **kwargs, &block) if args.first != :result

            kwargs[:in] = Utils::Array.wrap(kwargs[:in]) + [{method_name: raw(:result)}, {organizer: :itself}]

            args[0] = Services::RunOwnMethodInOrganizer

            chain.next(*args, **kwargs, &block)
          end

          private

          ##
          # @param object [Object] Can be any type.
          # @return [ConvenientService::Support::RawValue]
          #
          def raw(object)
            Support::RawValue.wrap(object)
          end
        end
      end
    end
  end
end
