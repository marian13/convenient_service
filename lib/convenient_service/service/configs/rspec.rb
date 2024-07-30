# frozen_string_literal: true

module ConvenientService
  module Service
    module Configs
      module RSpec
        include Config

        included do
          include Configs::Essential

          if Dependencies.rspec.loaded?
            concerns do
              unshift ConvenientService::Plugins::Service::CanHaveStubbedResults::Concern
            end

            middlewares :result do
              unshift ConvenientService::Plugins::Service::CanHaveStubbedResults::Middleware

              insert_before \
                ConvenientService::Plugins::Service::CanHaveStubbedResults::Middleware,
                ConvenientService::Plugins::Service::CountsStubbedResultsInvocations::Middleware
            end

            middlewares :result, scope: :class do
              unshift ConvenientService::Plugins::Service::CanHaveStubbedResults::Middleware

              insert_before \
                ConvenientService::Plugins::Service::CanHaveStubbedResults::Middleware,
                ConvenientService::Plugins::Service::CountsStubbedResultsInvocations::Middleware
            end

            class self::Result
              concerns do
                use ConvenientService::Plugins::Result::CanBeStubbedResult::Concern
                use ConvenientService::Plugins::Result::HasStubbedResultInvocationsCounter::Concern
              end

              middlewares :initialize do
                insert_before \
                  ConvenientService::Plugins::Result::HasJSendStatusAndAttributes::Middleware,
                  ConvenientService::Plugins::Result::HasStubbedResultInvocationsCounter::Middleware
              end
            end
          end
        end
        # rubocop:enable Lint/ConstantDefinitionInBlock
      end
    end
  end
end
