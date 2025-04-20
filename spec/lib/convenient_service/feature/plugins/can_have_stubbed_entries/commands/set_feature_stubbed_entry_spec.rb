# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Commands::SetFeatureStubbedEntry, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue

  include ConvenientService::RSpec::Helpers::StubService

  example_group "class methods" do
    describe ".call" do
      let(:command) { described_class }

      let(:feature) do
        Class.new do
          include ConvenientService::Feature::Standard::Config

          def main
            :main_entry_value
          end
        end
      end

      let(:entry) { :main }

      let(:cache) { ConvenientService::Support::Cache.backed_by(:thread_safe_hash).new }
      let(:value) { :stub_value }

      context "when `arguments` are NOT `nil` (match specific arguments)" do
        let(:arguments) { ConvenientService::Support::Arguments.new(:foo, {foo: :bar}) { :foo } }
        let(:key) { cache.keygen(*arguments.args, **arguments.kwargs, &arguments.block) }

        specify do
          expect { command.call(feature: feature, entry: entry, arguments: arguments, value: value) }
            .to delegate_to(ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Commands::FetchFeatureStubbedEntriesCache, :call)
            .with_arguments(feature: feature)
        end

        specify do
          allow(ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Commands::FetchFeatureStubbedEntriesCache).to receive(:call).with(feature: feature).and_return(cache)

          expect { command.call(feature: feature, entry: entry, arguments: arguments, value: value) }
            .to delegate_to(cache, :scope)
            .with_arguments(entry, backed_by: :thread_safe_array)
        end

        specify do
          allow(ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Commands::FetchFeatureStubbedEntriesCache).to receive(:call).with(feature: feature).and_return(cache)

          expect { command.call(feature: feature, entry: entry, arguments: arguments, value: value) }
            .to delegate_to(cache.scope!(entry, backed_by: :thread_safe_array), :write)
            .with_arguments(key, value)
            .and_return_its_value
        end

        context "when `entry` is string" do
          let(:entry) { "main" }

          it "does NOT set string key to cache" do
            command.call(feature: feature, entry: entry, arguments: arguments, value: value)

            expect(feature.stubbed_entries.exist?(entry)).to eq(false)
          end

          it "sets symbol key to cache" do
            command.call(feature: feature, entry: entry, arguments: arguments, value: value)

            expect(feature.stubbed_entries.scope(entry.to_sym, backed_by: :thread_safe_array).read(key)).to eq(value)
          end
        end
      end

      context "when `arguments` are `nil` (match any arguments)" do
        let(:arguments) { nil }

        specify do
          expect { command.call(feature: feature, entry: entry, arguments: arguments, value: value) }
            .to delegate_to(ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Commands::FetchFeatureStubbedEntriesCache, :call)
            .with_arguments(feature: feature)
        end

        specify do
          allow(ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Commands::FetchFeatureStubbedEntriesCache).to receive(:call).with(feature: feature).and_return(cache)

          expect { command.call(feature: feature, entry: entry, arguments: arguments, value: value) }
            .to delegate_to(cache, :scope)
            .with_arguments(entry, backed_by: :thread_safe_array)
        end

        specify do
          allow(ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Commands::FetchFeatureStubbedEntriesCache).to receive(:call).with(feature: feature).and_return(cache)

          expect { command.call(feature: feature, entry: entry, arguments: arguments, value: value) }
            .to delegate_to(cache.scope!(entry, backed_by: :thread_safe_array), :default=)
            .with_arguments(value)
            .and_return_its_value
        end

        context "when `entry` is string" do
          let(:entry) { "main" }

          it "does NOT set string key to cache" do
            command.call(feature: feature, entry: entry, arguments: arguments, value: value)

            expect(feature.stubbed_entries.exist?(entry)).to eq(false)
          end

          it "sets symbol key to cache" do
            command.call(feature: feature, entry: entry, arguments: arguments, value: value)

            expect(feature.stubbed_entries.scope(entry.to_sym, backed_by: :thread_safe_array).default).to eq(value)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
