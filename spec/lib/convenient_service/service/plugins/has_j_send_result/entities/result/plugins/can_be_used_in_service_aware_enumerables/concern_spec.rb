# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Concern, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { step_class }

      let(:step_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to include_module(described_class::InstanceMethods) }
    end
  end

  example_group "instance methods" do
    include ConvenientService::RSpec::Helpers::IgnoringException

    include ConvenientService::RSpec::Matchers::DelegateTo
    include ConvenientService::RSpec::Matchers::CacheItsValue
    include ConvenientService::RSpec::Matchers::Results

    describe "#key_mode" do
      let(:service) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success(foo: :foo, bar: :bar, baz: :baz)
          end
        end
      end

      context "when result is NOT modified" do
        let(:result) { service.result }

        it "returns `many` key mode" do
          expect(result.key_mode).to eq(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Entities::KeyModes.many)
        end

        it "does NOT return key mode from result extra keys" do
          expect(result.key_mode).not_to eq(result.extra_kwargs[:key_mode])
        end
      end

      context "when result is modified by `with_none_keys`" do
        let(:result) { service.result.with_none_keys }

        it "returns `none` key mode" do
          expect(result.key_mode).to eq(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Entities::KeyModes.none)
        end

        it "returns key mode from result extra keys" do
          expect(result.key_mode).to eq(result.extra_kwargs[:key_mode])
        end
      end

      context "when result is modified by `with_only_keys`" do
        context "when result is modified by `with_only_keys` with one key" do
          let(:result) { service.result.with_only_keys(:foo) }

          it "returns `one` key mode" do
            expect(result.key_mode).to eq(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Entities::KeyModes.one)
          end

          it "returns key mode from result extra keys" do
            expect(result.key_mode).to eq(result.extra_kwargs[:key_mode])
          end
        end

        context "when result is modified by `with_only_keys` with many keys" do
          let(:result) { service.result.with_only_keys(:foo, :bar) }

          it "returns `many` key mode" do
            expect(result.key_mode).to eq(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Entities::KeyModes.many)
          end

          it "returns key mode from result extra keys" do
            expect(result.key_mode).to eq(result.extra_kwargs[:key_mode])
          end
        end
      end

      context "when result is modified by `with_all_keys`" do
        let(:result) { service.result.with_all_keys }

        it "returns `many` key mode" do
          expect(result.key_mode).to eq(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Entities::KeyModes.many)
        end

        it "returns key mode from result extra keys" do
          expect(result.key_mode).not_to eq(result.extra_kwargs[:key_mode])
        end
      end

      context "when result is modified by `with_except_keys`" do
        let(:result) { service.result.with_except_keys(:foo) }

        it "returns `many` key mode" do
          expect(result.key_mode).to eq(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Entities::KeyModes.many)
        end

        it "returns key mode from result extra keys" do
          expect(result.key_mode).to eq(result.extra_kwargs[:key_mode])
        end
      end

      context "when result is modified by `with_extra_keys`" do
        let(:result) { service.result.with_extra_keys(qux: :qux) }

        it "returns `many` key mode" do
          expect(result.key_mode).to eq(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Entities::KeyModes.many)
        end

        it "returns key mode from result extra keys" do
          expect(result.key_mode).to eq(result.extra_kwargs[:key_mode])
        end
      end

      context "when result is modified by `with_renamed_keys`" do
        let(:result) { service.result.with_renamed_keys(foo: :qux) }

        it "returns `many` key mode" do
          expect(result.key_mode).to eq(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Entities::KeyModes.many)
        end

        it "returns key mode from result extra keys" do
          expect(result.key_mode).to eq(result.extra_kwargs[:key_mode])
        end
      end
    end

    describe "#with_none_keys" do
      let(:result) { service.result }

      context "when result has `failure` status" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              failure("from original result")
            end
          end
        end

        it "returns original result" do
          expect(result.with_none_keys).to be_failure.with_message("from original result")
        end

        context "when data has key for dropping" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                failure(foo: :foo, bar: :bar, baz: :baz)
              end
            end
          end

          it "ignores that key" do
            expect(result.with_none_keys).to be_failure.with_data(foo: :foo, bar: :bar, baz: :baz)
          end
        end
      end

      context "when result has `error` status" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              error("from original result")
            end
          end
        end

        it "returns original result" do
          expect(result.with_none_keys).to be_error.with_message("from original result")
        end

        context "when data has key for dropping" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                error(foo: :foo, bar: :bar, baz: :baz)
              end
            end
          end

          it "ignores that key" do
            expect(result.with_none_keys).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz)
          end
        end
      end

      context "when result has `success` status" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success(foo: :foo, bar: :bar, baz: :baz)
            end
          end
        end

        let(:keys) { [:foo, :baz] }

        it "drop all keys" do
          expect(result.with_none_keys).to be_success.without_data
        end
      end
    end

    describe "#with_only_keys" do
      let(:result) { service.result }

      context "when result has `failure` status" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              failure("from original result")
            end
          end
        end

        it "returns original result" do
          expect(result.with_only_keys(:foo, :bar)).to be_failure.with_message("from original result")
        end

        context "when data has key for only selection" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                failure(foo: :foo, bar: :bar, baz: :baz)
              end
            end
          end

          it "ignores that key" do
            expect(result.with_only_keys(:foo, :bar)).to be_failure.with_data(foo: :foo, bar: :bar, baz: :baz)
          end
        end
      end

      context "when result has `error` status" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              error("from original result")
            end
          end
        end

        it "returns original result" do
          expect(result.with_only_keys(:foo, :bar)).to be_error.with_message("from original result")
        end

        context "when data has key for only selection" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                error(foo: :foo, bar: :bar, baz: :baz)
              end
            end
          end

          it "ignores that key" do
            expect(result.with_only_keys(:foo, :bar)).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz)
          end
        end
      end

      context "when result has `success` status" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success(foo: :foo, bar: :bar, baz: :baz)
            end
          end
        end

        let(:keys) { [:foo, :baz] }

        it "selects data keys according to `keys`" do
          expect(result.with_only_keys(*keys)).to be_success.with_data(foo: :foo, baz: :baz)
        end

        context "when original result does NOT have attribute by `key`" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success(foo: :foo, bar: :bar)
              end
            end
          end

          let(:exception_message) do
            <<~TEXT
              Data attribute by key `:baz` does NOT exist. That is why it can NOT be selected. Make sure the corresponding result has it.
            TEXT
          end

          it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForOnly`" do
            expect { result.with_only_keys(*keys) }
              .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForOnly)
              .with_message(exception_message)
          end
        end

        context "when `keys` are empty" do
          let(:keys) { [] }

          it "returns result without keys" do
            expect(result.with_only_keys(*keys)).to be_success.without_data
          end
        end
      end
    end

    describe "#with_all_keys" do
      let(:result) { service.result }

      context "when result has `failure` status" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              failure("from original result")
            end
          end
        end

        it "returns original result" do
          expect(result.with_all_keys).to be_failure.with_message("from original result")
        end

        context "when data has key for selection" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                failure(foo: :foo, bar: :bar, baz: :baz)
              end
            end
          end

          it "ignores that key" do
            expect(result.with_only_keys(:foo).with_all_keys).to be_failure.with_data(foo: :foo, bar: :bar, baz: :baz)
          end
        end
      end

      context "when result has `error` status" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              error("from original result")
            end
          end
        end

        it "returns original result" do
          expect(result.with_all_keys).to be_error.with_message("from original result")
        end

        context "when data has key for selection" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                error(foo: :foo, bar: :bar, baz: :baz)
              end
            end
          end

          it "ignores that key" do
            expect(result.with_only_keys(:foo).with_all_keys).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz)
          end
        end
      end

      context "when result has `success` status" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success(foo: :foo, bar: :bar, baz: :baz)
            end
          end
        end

        let(:keys) { [:foo, :baz] }

        it "selects all keys" do
          expect(result.with_all_keys).to be_success.with_data(foo: :foo, bar: :bar, baz: :baz)
        end
      end
    end

    describe "#with_except_keys" do
      let(:result) { service.result }

      context "when result has `failure` status" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              failure("from original result")
            end
          end
        end

        it "returns original result" do
          expect(result.with_only_keys(:foo, :bar)).to be_failure.with_message("from original result")
        end

        context "when data has key for except dropping" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                failure(foo: :foo, bar: :bar, baz: :baz)
              end
            end
          end

          it "ignores that key" do
            expect(result.with_except_keys(:foo)).to be_failure.with_data(foo: :foo, bar: :bar, baz: :baz)
          end
        end
      end

      context "when result has `error` status" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              error("from original result")
            end
          end
        end

        it "returns original result" do
          expect(result.with_only_keys(:foo, :bar)).to be_error.with_message("from original result")
        end

        context "when data has key for except dropping" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                error(foo: :foo, bar: :bar, baz: :baz)
              end
            end
          end

          it "ignores that key" do
            expect(result.with_except_keys(:foo)).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz)
          end
        end
      end

      context "when result has `success` status" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success(foo: :foo, bar: :bar, baz: :baz)
            end
          end
        end

        let(:keys) { [:foo, :baz] }

        it "drops data keys according to `keys`" do
          expect(result.with_except_keys(*keys)).to be_success.with_data(bar: :bar)
        end

        context "when original result does NOT have attribute by `key`" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success(foo: :foo, bar: :bar)
              end
            end
          end

          let(:exception_message) do
            <<~TEXT
              Data attribute by key `:baz` does NOT exist. That is why it can NOT be dropped. Make sure the corresponding result has it.
            TEXT
          end

          it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForExcept`" do
            expect { result.with_except_keys(*keys) }
              .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForExcept)
              .with_message(exception_message)
          end
        end

        context "when `keys` are empty" do
          let(:keys) { [] }

          it "returns result with all keys" do
            expect(result.with_except_keys(*keys)).to be_success.with_data(foo: :foo, bar: :bar, baz: :baz)
          end
        end
      end
    end

    describe "#with_extra_keys" do
      let(:result) { service.result }

      context "when result has `failure` status" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              failure("from original result")
            end
          end
        end

        it "returns original result" do
          expect(result.with_extra_keys(foo: :qux)).to be_failure.with_message("from original result")
        end

        context "when data has key for overriding" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                failure(foo: :foo, bar: :bar, baz: :baz)
              end
            end
          end

          it "ignores that key" do
            expect(result.with_extra_keys(foo: :qux)).to be_failure.with_data(foo: :foo, bar: :bar, baz: :baz)
          end
        end
      end

      context "when result has `error` status" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              error("from original result")
            end
          end
        end

        it "returns original result" do
          expect(result.with_extra_keys(foo: :qux)).to be_error.with_message("from original result")
        end

        context "when data has key for overriding" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                error(foo: :foo, bar: :bar, baz: :baz)
              end
            end
          end

          it "ignores that key" do
            expect(result.with_extra_keys(foo: :qux)).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz)
          end
        end
      end

      context "when result has `success` status" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success(foo: :foo, bar: :bar, baz: :baz)
            end
          end
        end

        let(:values) { {qux: :qux, quux: :quux} }

        it "merges data keys according to `values`" do
          expect(result.with_extra_keys(**values)).to be_success.with_data(foo: :foo, bar: :bar, baz: :baz, qux: :qux, quux: :quux)
        end

        context "when data has key for overriding" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success(foo: :foo, bar: :bar, baz: :baz)
              end
            end
          end

          let(:values) { {foo: :qux, baz: :quux} }

          it "overrides those data keys according to `values`" do
            expect(result.with_extra_keys(**values)).to be_success.with_data(foo: :qux, bar: :bar, baz: :quux)
          end
        end

        context "when `values` are empty" do
          let(:values) { {} }

          it "returns original result" do
            expect(result.with_extra_keys(**values)).to be_success.with_data(foo: :foo, bar: :bar, baz: :baz)
          end
        end
      end
    end

    describe "#with_renamed_keys" do
      let(:result) { service.result }

      context "when result has `failure` status" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              failure("from original result")
            end
          end
        end

        it "returns original result" do
          expect(result.with_renamed_keys(foo: :qux)).to be_failure.with_message("from original result")
        end

        context "when data has key for renaming" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                failure(foo: :foo, bar: :bar, baz: :baz)
              end
            end
          end

          it "ignores that key" do
            expect(result.with_renamed_keys(foo: :qux)).to be_failure.with_data(foo: :foo, bar: :bar, baz: :baz)
          end
        end
      end

      context "when result has `error` status" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              error("from original result")
            end
          end
        end

        it "returns original result" do
          expect(result.with_renamed_keys(foo: :qux)).to be_error.with_message("from original result")
        end

        context "when data has key for renaming" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                error(foo: :foo, bar: :bar, baz: :baz)
              end
            end
          end

          it "ignores that key" do
            expect(result.with_renamed_keys(foo: :qux)).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz)
          end
        end
      end

      context "when result has `success` status" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success(foo: :foo, bar: :bar, baz: :baz)
            end
          end
        end

        let(:renamings) { {foo: :qux, baz: :quux} }

        it "renames data keys according to `renamings`" do
          expect(result.with_renamed_keys(**renamings)).to be_success.with_data(qux: :foo, bar: :bar, quux: :baz)
        end

        context "when original result does NOT have attribute by `key`" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success(foo: :foo, bar: :bar)
              end
            end
          end

          let(:exception_message) do
            <<~TEXT
              Data attribute by key `:baz` does NOT exist. That is why it can NOT be renamed to `:quux`. Make sure the corresponding result has it.
            TEXT
          end

          it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForRename`" do
            expect { result.with_renamed_keys(**renamings) }
              .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForRename)
              .with_message(exception_message)
          end
        end

        context "when `renamings` are empty" do
          let(:renamings) { {} }

          it "returns result with all keys" do
            expect(result.with_renamed_keys(**renamings)).to be_success.with_data(foo: :foo, bar: :bar, baz: :baz)
          end
        end
      end
    end

    describe "#to_service_aware_iteration_block_value" do
      context "when step result status is `success`" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success(foo: :foo, bar: :bar, baz: :baz)
            end
          end
        end

        context "when result outputs are NOT set" do
          let(:result) { service.result }

          it "returns result data values that corresponds to all outputs" do
            expect(result.to_service_aware_iteration_block_value).to eq({foo: :foo, bar: :bar, baz: :baz})
          end
        end

        context "when result has NO outputs" do
          let(:result) { service.result.with_none_keys }

          it "returns `true`" do
            expect(result.to_service_aware_iteration_block_value).to be(true)
          end
        end

        context "when result has one output" do
          let(:result) { service.result.with_only_keys(:foo) }

          it "returns result data value that corresponds to that one output" do
            expect(result.to_service_aware_iteration_block_value).to eq(:foo)
          end

          context "when result does NOT have value for that one output" do
            let(:result) { service.result.with_only_keys(:qux) }

            let(:exception_message) do
              <<~TEXT
                Data attribute by key `:qux` does NOT exist. That is why it can NOT be selected. Make sure the corresponding result has it.
              TEXT
            end

            it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForOnly`" do
              expect { result.to_service_aware_iteration_block_value }
                .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForOnly)
                .with_message(exception_message)
            end
          end
        end

        context "when result has many outputs" do
          let(:result) { service.result.with_only_keys(:foo, :bar) }

          it "returns result data values that corresponds to those many outputs" do
            expect(result.to_service_aware_iteration_block_value).to eq({foo: :foo, bar: :bar})
          end

          context "when result does NOT have value for that one output" do
            let(:result) { service.result.with_only_keys(:qux) }

            let(:exception_message) do
              <<~TEXT
                Data attribute by key `:qux` does NOT exist. That is why it can NOT be selected. Make sure the corresponding result has it.
              TEXT
            end

            it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForOnly`" do
              expect { result.to_service_aware_iteration_block_value }
                .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForOnly)
                .with_message(exception_message)
            end
          end
        end

        context "when result has all outputs" do
          let(:result) { service.result.with_all_keys }

          it "returns result data values that corresponds to all outputs" do
            expect(result.to_service_aware_iteration_block_value).to eq({foo: :foo, bar: :bar, baz: :baz})
          end

          context "when result does NOT have value for that one output" do
            let(:result) { service.result.with_only_keys(:qux) }

            let(:exception_message) do
              <<~TEXT
                Data attribute by key `:qux` does NOT exist. That is why it can NOT be selected. Make sure the corresponding result has it.
              TEXT
            end

            it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForOnly`" do
              expect { result.to_service_aware_iteration_block_value }
                .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForOnly)
                .with_message(exception_message)
            end
          end
        end
      end

      context "when result status is `failure`" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              failure("from service")
            end
          end
        end

        context "when result outputs are NOT set" do
          let(:result) { service.result }

          it "returns `nil`" do
            expect(result.to_service_aware_iteration_block_value).to be_nil
          end
        end

        context "when result has NO outputs" do
          let(:result) { service.result.with_none_keys }

          it "returns `false`" do
            expect(result.to_service_aware_iteration_block_value).to be(false)
          end
        end

        context "when result has one output" do
          let(:result) { service.result.with_only_keys(:foo) }

          it "returns `nil`" do
            expect(result.to_service_aware_iteration_block_value).to be_nil
          end
        end

        context "when result has many outputs" do
          let(:result) { service.result.with_only_keys(:foo, :bar) }

          it "returns `nil`" do
            expect(result.to_service_aware_iteration_block_value).to be_nil
          end
        end

        context "when result has all outputs" do
          let(:result) { service.result.with_all_keys }

          it "returns `nil`" do
            expect(result.to_service_aware_iteration_block_value).to be_nil
          end
        end
      end

      context "when result status is `error`" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              error("from service")
            end
          end
        end

        context "when result outputs are NOT set" do
          let(:result) { service.result }

          it "throws `:propagated_result`" do
            expect { result.to_service_aware_iteration_block_value }.to throw_symbol(:propagated_result, {propagated_result: result})
          end
        end

        context "when result has NO outputs" do
          let(:result) { service.result.with_none_keys }

          it "throws `:propagated_result`" do
            expect { result.to_service_aware_iteration_block_value }.to throw_symbol(:propagated_result, {propagated_result: result})
          end
        end

        context "when result has one output" do
          let(:result) { service.result.with_only_keys(:foo) }

          it "throws `:propagated_result`" do
            expect { result.to_service_aware_iteration_block_value }.to throw_symbol(:propagated_result, {propagated_result: result})
          end
        end

        context "when result has many outputs" do
          let(:result) { service.result.with_only_keys(:foo, :bar) }

          it "throws `:propagated_result`" do
            expect { result.to_service_aware_iteration_block_value }.to throw_symbol(:propagated_result, {propagated_result: result})
          end
        end

        context "when result has all outputs" do
          let(:result) { service.result.with_all_keys }

          it "throws `:propagated_result`" do
            expect { result.to_service_aware_iteration_block_value }.to throw_symbol(:propagated_result, {propagated_result: result})
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
