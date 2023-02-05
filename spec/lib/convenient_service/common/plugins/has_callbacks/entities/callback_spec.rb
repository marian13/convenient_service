# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Common::Plugins::HasCallbacks::Entities::Callback do
  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { described_class.new(types: [:foo, :bar], block: proc { :foo }) }

    it { is_expected.to have_attr_reader(:types) }
    it { is_expected.to have_attr_reader(:block) }
  end

  example_group "class methods" do
    describe ".new" do
      subject(:callback) { described_class.new(types: types, block: double) }

      let(:types) { [:before, :result] }
      let(:casted_types) { ConvenientService::Common::Plugins::HasCallbacks::Entities::TypeCollection.new(types: types) }

      it "casts types to `ConvenientService::Common::Plugins::HasCallbacks::Entities::TypeCollection` instance" do
        expect(callback.types).to eq(casted_types)
      end
    end
  end

  example_group "instance alias methods" do
    include ConvenientService::RSpec::Matchers::HaveAliasMethod

    subject { described_class.new(types: [], block: double) }

    it { is_expected.to have_alias_method(:yield, :call) }
    it { is_expected.to have_alias_method(:[], :call) }
    it { is_expected.to have_alias_method(:===, :call) }
  end

  example_group "instance methods" do
    subject(:callback) { described_class.new(types: types, block: callback_block) }

    let(:params) { {types: types, block: callback_block} }
    let(:types) { [:before, :result] }
    let(:callback_block) { proc { :callback } }

    let(:arguments_args) { [:foo, :bar] }
    let(:arguments_kwargs) { {foo: :bar} }
    let(:arguments_block) { proc { :foo } }

    let(:arguments) { ConvenientService::Support::Arguments.new(*arguments_args, **arguments_kwargs, &arguments_block) }

    describe "#called?" do
      context "when callback is NOT called" do
        it "returns false" do
          expect(callback.called?).to eq(false)
        end
      end

      context "when callback is called" do
        it "returns true" do
          callback.call

          expect(callback.called?).to eq(true)
        end
      end
    end

    describe "#not_called?" do
      context "when callback is NOT called" do
        it "returns true" do
          expect(callback.not_called?).to eq(true)
        end
      end

      context "when callback is called" do
        it "returns false" do
          callback.call

          expect(callback.not_called?).to eq(false)
        end
      end
    end

    describe "#call" do
      include ConvenientService::RSpec::Matchers::DelegateTo

      specify do
        expect { callback.call(*arguments_args, arguments_kwargs, arguments_block) }
          .to delegate_to(callback_block, :call)
          .with_arguments(*arguments_args, arguments_kwargs, arguments_block)
          .and_return_its_value
      end

      it "marks callback as called" do
        expect { callback.call(*arguments_args, arguments_kwargs, arguments_block) }.to change(callback, :called?).from(false).to(true)
      end
    end

    describe "#call_in_context" do
      include ConvenientService::RSpec::Matchers::DelegateTo

      let(:context) { Object.new }

      specify do
        expect { callback.call_in_context(context) }
          .to delegate_to(context, :instance_exec)
          .with_arguments(&callback_block)
          .and_return_its_value
      end

      it "marks callback as called" do
        expect { callback.call_in_context(context) }.to change(callback, :called?).from(false).to(true)
      end
    end

    describe "#call_in_context_with_arguments" do
      include ConvenientService::RSpec::Matchers::DelegateTo

      let(:context) { Object.new }

      specify do
        expect { callback.call_in_context_with_arguments(context, *arguments_args, **arguments_kwargs, &arguments_block) }
          .to delegate_to(context, :instance_exec)
          .with_arguments(arguments, &callback_block)
          .and_return_its_value
      end

      it "marks callback as called" do
        expect { callback.call_in_context_with_arguments(context, *arguments_args, **arguments_kwargs, &arguments_block) }.to change(callback, :called?).from(false).to(true)
      end
    end

    describe "#call_in_context_with_value_and_arguments" do
      include ConvenientService::RSpec::Matchers::DelegateTo

      let(:context) { Object.new }
      let(:value) { :foo }

      specify do
        expect { callback.call_in_context_with_value_and_arguments(context, value, *arguments_args, **arguments_kwargs, &arguments_block) }
          .to delegate_to(context, :instance_exec)
          .with_arguments(value, arguments, &callback_block)
          .and_return_its_value
      end

      it "marks callback as called" do
        expect { callback.call_in_context_with_value_and_arguments(context, value, *arguments_args, **arguments_kwargs, &arguments_block) }.to change(callback, :called?).from(false).to(true)
      end
    end

    describe "#==" do
      context "when calbacks have different classes" do
        let(:other) { "string" }

        it "returns nil" do
          expect(callback == other).to eq(nil)
        end
      end

      context "when calbacks have different types" do
        let(:other) { described_class.new(**params.merge(types: [:after, :step])) }

        it "returns false" do
          expect(callback == other).to eq(false)
        end
      end

      context "when `other` has different `block`" do
        let(:other) { described_class.new(**params.merge(block: other_callback_block)) }
        let(:other_callback_block) { proc { :baz } }

        it "returns false" do
          expect(callback == other).to eq(false)
        end

        ##
        # TODO: Refactor.
        #
        # rubocop:disable Lint/Void, RSpec/ExampleLength
        it "uses `source_location` to compare blocks" do
          callback_block_source_location = double
          other_callback_block_source_location = double

          allow(params[:block]).to receive(:source_location).and_return(callback_block_source_location)
          allow(other_callback_block).to receive(:source_location).and_return(other_callback_block_source_location)
          allow(callback_block_source_location).to receive(:==).with(other_callback_block_source_location)

          callback == other

          expect(callback_block_source_location).to have_received(:==)
        end
        # rubocop:enable Lint/Void, RSpec/ExampleLength
      end

      context "when calbacks have same attributes" do
        let(:other) { described_class.new(**params) }

        it "returns true" do
          expect(callback == other).to eq(true)
        end
      end
    end

    describe "#to_proc" do
      it "returns block" do
        expect(callback.to_proc).to eq(callback_block)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
