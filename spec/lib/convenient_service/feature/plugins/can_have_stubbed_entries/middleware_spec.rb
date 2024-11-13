# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Middleware, type: :standard do
  let(:middleware) { described_class }

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { middleware }

    it { is_expected.to be_descendant_of(ConvenientService::MethodChainMiddleware) }
  end

  example_group "class methods" do
    describe ".intended_methods" do
      let(:spec) do
        Class.new(ConvenientService::MethodChainMiddleware) do
          intended_for :trigger, scope: any_scope, entity: :feature
        end
      end

      it "returns intended methods" do
        expect(middleware.intended_methods).to eq(spec.intended_methods)
      end
    end
  end

  shared_examples "verify middleware behavior" do
    example_group "instance methods" do
      describe "#call" do
        include ConvenientService::RSpec::Helpers::StubEntry
        include ConvenientService::RSpec::Helpers::WrapMethod

        include ConvenientService::RSpec::Matchers::CallChainNext
        include ConvenientService::RSpec::Matchers::Results

        subject(:method_value) { method.call(entry_name, *entry_arguments.args, **entry_arguments.kwargs, &entry_arguments.block) }

        let(:method) { wrap_method(entity, :trigger, observe_middleware: middleware) }

        let(:entry_name) { :main }
        let(:args) { [:foo] }
        let(:kwargs) { {foo: :bar} }
        let(:block) { proc { :foo } }

        let(:feature_class) do
          Class.new.tap do |klass|
            klass.class_exec(middleware, scope) do |middleware, scope|
              include ConvenientService::Feature::Standard::Config

              middlewares :trigger, scope: scope do
                observe middleware
              end

              entry :main

              def main(*args, **kwargs, &block)
                :main_entry_value
              end
            end
          end
        end

        context "when cache does NOT contain any stubs" do
          specify do
            expect { method_value }
              .to call_chain_next.on(method)
              .with_arguments(entry_name, *entry_arguments.args, **entry_arguments.kwargs, &entry_arguments.block)
              .and_return_its_value
          end

          it "returns original entry return value" do
            expect(method_value).to eq(:main_entry_value)
          end
        end

        context "when cache contains one stub" do
          context "when that one stub with different arguments" do
            before do
              stub_entry(feature_class, entry_name)
                .with_arguments(:bar, **kwargs, &block)
                .to return_value(:different_arguments)
            end

            it "returns original entry return value" do
              expect(method_value).to eq(:main_entry_value)
            end
          end

          context "when that one stub with same arguments" do
            before do
              stub_entry(feature_class, entry_name)
                .with_arguments(*args, **kwargs, &block)
                .to return_value(:same_arguments)
            end

            it "returns stub with same arguments" do
              expect(method_value).to eq(:same_arguments)
            end
          end

          context "when that one stub with default (any arguments)" do
            before do
              stub_entry(feature_class, entry_name)
                .to return_value(:with_default)
            end

            it "returns stub with default (any arguments)" do
              expect(method_value).to eq(:with_default)
            end
          end

          context "when that one stub with any arguments" do
            before do
              stub_entry(feature_class, entry_name)
                .with_any_arguments
                .to return_value(:with_any_arguments)
            end

            it "returns stub with any arguments" do
              expect(method_value).to eq(:with_any_arguments)
            end
          end

          context "when that one stub without arguments" do
            before do
              stub_entry(feature_class, entry_name)
                .without_arguments
                .to return_value(:without_arguments)
            end

            it "returns original entry return value" do
              expect(method_value).to eq(:main_entry_value)
            end
          end
        end

        context "when cache contains multiple stubs" do
          context "when all of them with different arguments" do
            before do
              stub_entry(feature_class, entry_name)
                .with_arguments(:bar, **kwargs, &block)
                .to return_value(:different_arguments)

              stub_entry(feature_class, entry_name)
                .with_arguments(:baz, **kwargs, &block)
                .to return_value(:different_arguments)
            end

            it "returns original entry return value" do
              expect(method_value).to eq(:main_entry_value)
            end
          end

          context "when one of them with different arguments and one with same arguments" do
            before do
              stub_entry(feature_class, entry_name)
                .with_arguments(:bar, **kwargs, &block)
                .to return_value(:different_arguments)

              stub_entry(feature_class, entry_name)
                .with_arguments(*args, **kwargs, &block)
                .to return_value(:same_arguments)
            end

            it "returns stub with same arguments" do
              expect(method_value).to eq(:same_arguments)
            end
          end

          context "when one of them with different arguments and one with default (any arguments)" do
            before do
              stub_entry(feature_class, entry_name)
                .with_arguments(:bar, **kwargs, &block)
                .to return_value(:different_arguments)

              stub_entry(feature_class, entry_name)
                .to return_value(:with_default)
            end

            it "returns stub with any arguments" do
              expect(method_value).to eq(:with_default)
            end
          end

          context "when one of them with different arguments and one with any arguments" do
            before do
              stub_entry(feature_class, entry_name)
                .with_arguments(:bar, **kwargs, &block)
                .to return_value(:different_arguments)

              stub_entry(feature_class, entry_name)
                .with_any_arguments
                .to return_value(:with_any_arguments)
            end

            it "returns stub with any arguments" do
              expect(method_value).to eq(:with_any_arguments)
            end
          end

          context "when one of them with different arguments and one without arguments" do
            before do
              stub_entry(feature_class, entry_name)
                .with_arguments(:bar, **kwargs, &block)
                .to return_value(:different_arguments)

              stub_entry(feature_class, entry_name)
                .without_arguments
                .to return_value(:without_arguments)
            end

            it "returns original entry return value" do
              expect(method_value).to eq(:main_entry_value)
            end
          end

          context "when one of them with same arguments and one with default (any arguments)" do
            before do
              stub_entry(feature_class, entry_name)
                .with_arguments(*args, **kwargs, &block)
                .to return_value(:same_arguments)

              stub_entry(feature_class, entry_name)
                .to return_value(:with_default)
            end

            it "returns stub same arguments" do
              expect(method_value).to eq(:same_arguments)
            end
          end

          context "when one of them with same arguments and one with any arguments" do
            before do
              stub_entry(feature_class, entry_name)
                .with_arguments(*args, **kwargs, &block)
                .to return_value(:same_arguments)

              stub_entry(feature_class, entry_name)
                .with_any_arguments
                .to return_value(:with_any_arguments)
            end

            it "returns stub same arguments" do
              expect(method_value).to eq(:same_arguments)
            end
          end

          context "when one of them with same arguments and one without arguments" do
            before do
              stub_entry(feature_class, entry_name)
                .with_arguments(*args, **kwargs, &block)
                .to return_value(:same_arguments)

              stub_entry(feature_class, entry_name)
                .without_arguments
                .to return_value(:without_arguments)
            end

            it "returns stub same arguments" do
              expect(method_value).to eq(:same_arguments)
            end
          end
        end
      end
    end
  end

  context "when entity is feature class" do
    include_examples "verify middleware behavior" do
      let(:entity) { feature_class }
      let(:scope) { :class }

      let(:entry_arguments) { ConvenientService::Support::Arguments.new(*args, **kwargs, &block) }
    end
  end

  context "when entity is feature instance" do
    include_examples "verify middleware behavior" do
      let(:entity) { feature_instance }
      let(:scope) { :instance }

      let(:entry_arguments) { ConvenientService::Support::Arguments.new(*args, **kwargs, &block) }

      let(:feature_instance) { feature_class.new }
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
