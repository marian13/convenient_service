# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Classes::DelegateTo::Entities::Inputs, type: :standard do
  include ConvenientService::RSpec::Matchers::CacheItsValue

  let(:inputs) { described_class.new(object: object, method: method, block_expectation: block_expectation) }

  let(:klass) do
    Class.new do
      def foo(...)
        bar(...)
      end

      def bar(...)
        "bar value"
      end
    end
  end

  let(:object) { klass.new }
  let(:method) { :bar }

  let(:block_expectation) { proc { object.foo } }

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { inputs }

    it { is_expected.to have_attr_reader(:values) }
  end

  example_group "class methods" do
    describe ".new" do
      it "set initial `values`" do
        expect(inputs.values).to eq({object: object, method: method, block_expectation: block_expectation})
      end
    end
  end

  example_group "instance methods" do
    describe "#block_expectation" do
      it "returns `block_expectation` passed to constructor" do
        expect(inputs.block_expectation).to eq(block_expectation)
      end
    end

    describe "#custom_return_value" do
      let(:expected_return_value_block) { proc { |delegation_value| "#{delegation_value} + custom return value" } }
      let(:custom_return_value) { "#{inputs.delegation_value} + custom return value" }

      before do
        inputs.update_expected_return_value_block(&expected_return_value_block)
      end

      context "when `custom_return_value` is NOT calculated yet" do
        before do
          inputs.values.delete(:custom_return_value)
        end

        it "sets `custom_return_value` value" do
          expect { inputs.custom_return_value }.to change { inputs.values[:custom_return_value] }.from(nil).to(custom_return_value)
        end

        it "returns just calculated `custom_return_value`" do
          expect(inputs.custom_return_value).to eq(custom_return_value)
        end
      end

      context "when `custom_return_value` is already calculated" do
        before do
          inputs.custom_return_value
        end

        it "returns that already calculated `custom_return_value`" do
          expect(inputs.custom_return_value).to eq(custom_return_value)
        end

        specify do
          expect { inputs.custom_return_value }.to cache_its_value
        end

        context "when `custom_return_value` returns falsey value" do
          let(:expected_return_value_block) { proc { false } }

          specify do
            expect { inputs.custom_return_value }.to cache_its_value
          end
        end
      end
    end

    describe "#delegation_value" do
      let(:delegation_value) { "bar value" }

      context "when `delegation_value` is NOT calculated yet" do
        before do
          inputs.values.delete(:delegation_value)
        end

        it "sets `delegation_value` value" do
          expect { inputs.delegation_value }.to change { inputs.values[:delegation_value] }.from(nil).to(delegation_value)
        end

        it "returns just calculated `delegation_value`" do
          expect(inputs.delegation_value).to eq(delegation_value)
        end
      end

      context "when `delegation_value` is already calculated" do
        before do
          inputs.delegation_value
        end

        it "returns that already calculated `delegation_value`" do
          expect(inputs.delegation_value).to eq(delegation_value)
        end

        specify do
          expect { inputs.delegation_value }.to cache_its_value
        end

        context "when `delegation_value` returns falsey value" do
          let(:klass) do
            Class.new do
              def foo(...)
                bar(...)
              end

              def bar(...)
                nil
              end
            end
          end

          specify do
            expect { inputs.delegation_value }.to cache_its_value
          end
        end
      end
    end

    describe "#expected_arguments" do
      context "when `expected_arguments` are NOT set" do
        before do
          inputs.expected_arguments = nil
        end

        it "returns null arguments" do
          expect(inputs.expected_arguments).to eq(ConvenientService::Support::Arguments.null_arguments)
        end
      end

      context "when `expected_arguments` are set" do
        let(:arguments) { ConvenientService::Support::Arguments.new(:foo, :bar) }

        before do
          inputs.expected_arguments = arguments
        end

        it "returns those set `expected_arguments`" do
          expect(inputs.expected_arguments).to eq(arguments)
        end
      end
    end

    describe "#expected_return_value_block" do
      context "when `expected_return_value_block` is NOT set" do
        it "returns default value block" do
          expect(inputs.expected_return_value_block).to be_instance_of(Proc)
        end

        example_group "default value block" do
          it "returns `ConvenientService::Support::UNDEFINED`" do
            expect(inputs.expected_return_value_block.call).to eq(ConvenientService::Support::UNDEFINED)
          end

          it "accepts delegation value as arg" do
            expect(inputs.expected_return_value_block.call(:foo)).to eq(ConvenientService::Support::UNDEFINED)
          end
        end
      end

      context "when `expected_return_value_block` is set" do
        let(:return_value_block) { proc { |delegation_value| delegation_value } }

        before do
          inputs.update_expected_return_value_block(&return_value_block)
        end

        it "returns that set `expected_return_value_block`" do
          expect(inputs.expected_return_value_block).to eq(return_value_block)
        end
      end
    end

    describe "#object" do
      it "returns `object` passed to constructor" do
        expect(inputs.object).to eq(object)
      end
    end

    describe "#method" do
      it "returns `method` passed to constructor" do
        expect(inputs.method).to eq(method)
      end
    end

    describe "#printable_method" do
      it "delegates to `ConvenientService::RSpec::Matchers::Classes::DelegateTo::Commands::GeneratePrintableMethod`" do
        allow(ConvenientService::RSpec::Matchers::Classes::DelegateTo::Commands::GeneratePrintableMethod).to receive(:call).with(object: object, method: method).and_call_original

        inputs.printable_method

        expect(ConvenientService::RSpec::Matchers::Classes::DelegateTo::Commands::GeneratePrintableMethod).to have_received(:call).with(object: object, method: method)
      end

      it "returns `ConvenientService::RSpec::Matchers::Classes::DelegateTo::Commands::GeneratePrintableMethod` value" do
        expect(inputs.printable_method).to eq(ConvenientService::RSpec::Matchers::Classes::DelegateTo::Commands::GeneratePrintableMethod.call(object: object, method: method))
      end

      it "caches its value" do
        expect(inputs.printable_method).to equal(inputs.printable_method)
      end
    end

    describe "#printable_block_expectation" do
      it "delegates to `ConvenientService::Utils::Proc.display`" do
        allow(ConvenientService::Utils::Proc).to receive(:display).with(block_expectation).and_call_original

        inputs.printable_block_expectation

        expect(ConvenientService::Utils::Proc).to have_received(:display).with(block_expectation)
      end

      it "returns `ConvenientService::Utils::Proc.display` value" do
        expect(inputs.printable_block_expectation).to eq(ConvenientService::Utils::Proc.display(block_expectation))
      end

      it "caches its value" do
        expect(inputs.printable_block_expectation).to equal(inputs.printable_block_expectation)
      end
    end

    describe "#has_call_original?" do
      context "when `should_call_original` value is NOT set" do
        before do
          inputs.values.delete(:should_call_original)
        end

        it "returns `false`" do
          expect(inputs.has_call_original?).to be(false)
        end
      end

      context "when `should_call_original` value is set" do
        before do
          inputs.should_call_original = false
        end

        it "returns `true`" do
          expect(inputs.has_call_original?).to be(true)
        end
      end
    end

    describe "#should_call_original?" do
      context "when `should_call_original` value is NOT set" do
        before do
          inputs.values.delete(:should_call_original)
        end

        it "defaults to `true`" do
          expect(inputs.should_call_original?).to be(true)
        end
      end

      context "when `should_call_original` value is set" do
        before do
          inputs.should_call_original = false
        end

        it "return that set value" do
          expect(inputs.should_call_original?).to be(false)
        end
      end
    end

    describe "#block_expectation=" do
      let(:block_expectation) { proc { :foo } }

      it "sets block expectation" do
        inputs.block_expectation = block_expectation

        expect(inputs.block_expectation).to eq(block_expectation)
      end

      it "returns block expectation" do
        expect(inputs.block_expectation = block_expectation).to eq(block_expectation)
      end
    end

    describe "#expected_arguments=" do
      let(:arguments) { ConvenientService::Support::Arguments.new }

      it "sets expected arguments" do
        inputs.expected_arguments = arguments

        expect(inputs.expected_arguments).to eq(arguments)
      end

      it "returns expected arguments" do
        expect(inputs.expected_arguments = arguments).to eq(arguments)
      end

      example_group "values resets" do
        before do
          allow(inputs.values).to receive(:delete).and_call_original
        end

        it "delegates to `values#delete` to reset `delegation_value`" do
          allow(inputs.values).to receive(:delete).with(:delegation_value).and_call_original

          inputs.expected_arguments = arguments

          expect(inputs.values).to have_received(:delete).with(:delegation_value)
        end

        it "delegates to `values#delete` to reset `custom_return_value`" do
          allow(inputs.values).to receive(:delete).with(:custom_return_value).and_call_original

          inputs.expected_arguments = arguments

          expect(inputs.values).to have_received(:delete).with(:custom_return_value)
        end
      end
    end

    describe "#should_call_original=" do
      let(:call_original) { false }

      it "sets block expectation" do
        inputs.should_call_original = call_original

        expect(inputs.should_call_original?).to eq(call_original)
      end

      it "returns block expectation" do
        expect(inputs.should_call_original = call_original).to eq(call_original)
      end
    end

    describe "#update_expected_return_value_block" do
      it "delegates to `values.delete` to reset `custom_return_value`" do
        allow(inputs.values).to receive(:delete).with(:custom_return_value).and_call_original

        inputs.update_expected_return_value_block(:foo)

        expect(inputs.values).to have_received(:delete).with(:custom_return_value)
      end

      context "when NO `return_value` is passed" do
        context "when NO `block` is passsed" do
          let(:exception_message) do
            <<~TEXT
              Returns custom value chaining has invalid arguments.

              Make sure you use one of the following forms:

              `and_return(custom_value)`
              `and_return { custom_value }`
              `and_return { |delegation_value| process_somehow(delegation_value) }`
            TEXT
          end

          it "raises `ConvenientService::RSpec::Matchers::Classes::DelegateTo::Exceptions::ReturnCustomValueChainingInvalidArguments`" do
            expect { inputs.update_expected_return_value_block }
              .to raise_error(ConvenientService::RSpec::Matchers::Classes::DelegateTo::Exceptions::ReturnCustomValueChainingInvalidArguments)
              .with_message(exception_message)
          end
        end

        context "when `block` is passed" do
          let(:block) { proc { |delegation_value| delegation_value } }

          it "returns `block`" do
            expect(inputs.update_expected_return_value_block(&block)).to eq(block)
          end

          it "sets that `block` as `expected_return_value_block`" do
            inputs.update_expected_return_value_block(&block)

            expect(inputs.expected_return_value_block).to eq(block)
          end
        end
      end

      context "when `return_value` is passed" do
        let(:return_value) { :foo }

        context "when NO `block` is passed" do
          it "returns proc that returns `return_value`" do
            expect(inputs.update_expected_return_value_block(return_value)).to be_instance_of(Proc)
          end

          it "sets that proc that returns `return_value` as `expected_return_value_block`" do
            inputs.update_expected_return_value_block(return_value)

            expect(inputs.expected_return_value_block.call).to eq(return_value)
          end

          example_group "proc that returns `return_value`" do
            let(:delegation_value) { :foo }

            it "accepts delegation value as arg" do
              inputs.update_expected_return_value_block(return_value)

              expect(inputs.expected_return_value_block.call(delegation_value)).to eq(return_value)
            end
          end
        end

        context "when `block` is passed" do
          let(:block) { proc { |delegation_value| delegation_value } }

          let(:exception_message) do
            <<~TEXT
              Returns custom value chaining has invalid arguments.

              Make sure you use one of the following forms:

              `and_return(custom_value)`
              `and_return { custom_value }`
              `and_return { |delegation_value| process_somehow(delegation_value) }`
            TEXT
          end

          it "raises `ConvenientService::RSpec::Matchers::Classes::DelegateTo::Exceptions::ReturnCustomValueChainingInvalidArguments`" do
            expect { inputs.update_expected_return_value_block(return_value, &block) }
              .to raise_error(ConvenientService::RSpec::Matchers::Classes::DelegateTo::Exceptions::ReturnCustomValueChainingInvalidArguments)
              .with_message(exception_message)
          end
        end
      end
    end

    example_group "comparison" do
      describe "#==" do
        let(:inputs) { described_class.new(object: object, method: method, block_expectation: block_expectation) }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `false`" do
            expect(inputs == other).to be_nil
          end
        end

        context "when `other` has different `values`" do
          let(:other) { described_class.new(object: Object.new, method: method, block_expectation: block_expectation) }

          it "returns `false`" do
            expect(inputs == other).to be(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(object: object, method: method, block_expectation: block_expectation) }

          it "returns `true`" do
            expect(inputs == other).to be(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
