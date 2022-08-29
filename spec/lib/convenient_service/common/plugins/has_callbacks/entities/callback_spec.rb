# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
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

      it "casts types to `ConvenientService::Common::Plugins::HasCallbacks::Entities::TypeCollection' instance" do
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
    subject(:callback) { described_class.new(types: types, block: block) }

    let(:params) { {types: types, block: block} }
    let(:types) { [:before, :result] }
    let(:block) { proc { :foo } }

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
      it "calls block" do
        allow(block).to receive(:call).and_call_original

        callback.call

        expect(block).to have_received(:call)
      end

      it "returns result of block calling" do
        expect(callback.call).to eq(block.call)
      end

      it "passes all its args to block" do
        args = [:foo, :bar]

        allow(block).to receive(:call).with(*args).and_call_original

        callback.call(*args)

        expect(block).to have_received(:call)
      end

      it "passes all its kwargs to block" do
        kwargs = {foo: :bar}

        allow(block).to receive(:call).with(**kwargs).and_call_original

        callback.call(**kwargs)

        expect(block).to have_received(:call)
      end

      it "marks callback as called" do
        expect { callback.call }.to change(callback, :called?).from(false).to(true)
      end
    end

    describe "#call_in_context" do
      let(:context) { Object.new }

      it "calls instance exec of context" do
        allow(context).to receive(:instance_exec).and_call_original

        callback.call_in_context(context)

        expect(context).to have_received(:instance_exec)
      end

      it "returns result of block calling inside instance exec of context" do
        expect(callback.call_in_context(context)).to eq(context.instance_exec(&block))
      end

      it "passes all its args to instance exec of context" do
        args = [:foo, :bar]

        allow(context).to receive(:instance_exec).with(*args).and_call_original

        callback.call_in_context(context, *args)

        expect(context).to have_received(:instance_exec)
      end

      it "passes all its kwargs to instance exec of context" do
        kwargs = {foo: :bar}

        allow(context).to receive(:instance_exec).with(**kwargs).and_call_original

        callback.call_in_context(context, **kwargs)

        expect(context).to have_received(:instance_exec)
      end

      it "marks callback as called" do
        expect { callback.call_in_context(context) }.to change(callback, :called?).from(false).to(true)
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

      context "when `other' has different `block'" do
        let(:other) { described_class.new(**params.merge(block: other_block)) }
        let(:other_block) { proc { :baz } }

        it "returns false" do
          expect(callback == other).to eq(false)
        end

        ##
        # TODO: Refactor.
        #
        # rubocop:disable Lint/Void, RSpec/ExampleLength
        it "uses `source_location' to compare blocks" do
          callback_block_source_location = double
          other_block_source_location = double

          allow(params[:block]).to receive(:source_location).and_return(callback_block_source_location)
          allow(other_block).to receive(:source_location).and_return(other_block_source_location)
          allow(callback_block_source_location).to receive(:==).with(other_block_source_location)

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
        expect(callback.to_proc).to eq(block)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
