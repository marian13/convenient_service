# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveModifiedData::Concern, type: :standard do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { result_class }

      let(:result_class) do
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

        specify do
          expect { result.with_renamed_keys(foo: :qux) }.to cache_its_value
        end

        context "when data has key for renaming" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                failure(foo: :foo)
              end
            end
          end

          it "ignores that key" do
            expect(result.with_renamed_keys(foo: :qux)).to be_failure.with_data(foo: :foo)
          end
        end
      end

      context "when result has `error` status" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              failure("from original result")
            end
          end
        end

        specify do
          expect { result.with_renamed_keys(foo: :qux) }.to cache_its_value
        end

        context "when data has key for renaming" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                error(foo: :foo)
              end
            end
          end

          it "ignores that key" do
            expect(result.with_renamed_keys(foo: :qux)).to be_error.with_data(foo: :foo)
          end
        end
      end

      context "when result has success status" do
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
          expect(result.with_renamed_keys(renamings)).to be_success.with_data(qux: :foo, bar: :bar, quux: :baz)
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

          it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveModifiedData::Exceptions::NotExistingAttribute`" do
            expect { result.with_renamed_keys(renamings) }
              .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveModifiedData::Exceptions::NotExistingAttribute)
              .with_message(exception_message)
          end

          specify do
            expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveModifiedData::Exceptions::NotExistingAttribute) { result.with_renamed_keys(renamings) } }
              .to delegate_to(ConvenientService, :raise)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
