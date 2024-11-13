# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::SetServiceStubbedResult, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue

  include ConvenientService::RSpec::Helpers::StubService

  example_group "class methods" do
    describe ".call" do
      let(:command) { described_class }

      let(:service) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success
          end
        end
      end

      let(:cache) { ConvenientService::Support::Cache.backed_by(:thread_safe_array).new }
      let(:result) { service.error }

      context "when `arguments` are NOT `nil` (match specific arguments)" do
        let(:key) { cache.keygen(*arguments.args, **arguments.kwargs, &arguments.block) }
        let(:arguments) { ConvenientService::Support::Arguments.new(:foo, {foo: :bar}) { :foo } }

        specify do
          expect { command.call(service: service, arguments: arguments, result: result) }
            .to delegate_to(ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::FetchServiceStubbedResultsCache, :call)
            .with_arguments(service: service)
        end

        specify do
          allow(ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::FetchServiceStubbedResultsCache).to receive(:call).with(service: service).and_return(cache)

          expect { command.call(service: service, arguments: arguments, result: result) }
            .to delegate_to(cache, :write)
            .with_arguments(key, result)
            .and_return_its_value
        end
      end

      context "when `arguments` are `nil` (match any arguments)" do
        let(:arguments) { nil }

        specify do
          expect { command.call(service: service, arguments: arguments, result: result) }
            .to delegate_to(ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::FetchServiceStubbedResultsCache, :call)
            .with_arguments(service: service)
        end

        specify do
          allow(ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::FetchServiceStubbedResultsCache).to receive(:call).with(service: service).and_return(cache)

          expect { command.call(service: service, arguments: arguments, result: result) }
            .to delegate_to(cache, :default=)
            .with_arguments(result)
            .and_return_its_value
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
