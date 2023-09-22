# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::GetServiceStubbedResult do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::CacheItsValue

  include ConvenientService::RSpec::Helpers::StubService

  example_group "class methods" do
    describe ".call" do
      let(:command) { described_class }

      let(:service) do
        Class.new do
          include ConvenientService::Service::Configs::Standard

          def result
            success
          end
        end
      end

      let(:cache) { ConvenientService::Support::Cache.create(backend: :thread_safe_array) }
      let(:arguments) { ConvenientService::Support::Arguments.new(:foo, {foo: :bar}) { :foo } }
      let(:key) { cache.keygen(*arguments.args, **arguments.kwargs, &arguments.block) }

      specify do
        expect { command.call(service: service, arguments: arguments) }
          .to delegate_to(ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::FetchServiceStubbedResultsCache, :call)
          .with_arguments(service: service)
      end

      specify do
        allow(ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::FetchServiceStubbedResultsCache).to receive(:call).with(service: service).and_return(cache)

        expect { command.call(service: service, arguments: arguments) }
          .to delegate_to(cache, :read)
          .with_arguments(key)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
