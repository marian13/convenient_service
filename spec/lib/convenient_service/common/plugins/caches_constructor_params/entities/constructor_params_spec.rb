# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Common::Plugins::CachesConstructorParams::Entities::ConstructorParams do
  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { constructor_params }

    let(:constructor_params) { described_class.new(args: args, kwargs: kwargs, block: block) }

    let(:args) { [:foo] }
    let(:kwargs) { {foo: :bar} }
    let(:block) { proc { :foo } }

    it { is_expected.to have_attr_reader(:args) }
    it { is_expected.to have_attr_reader(:kwargs) }
    it { is_expected.to have_attr_reader(:block) }
  end

  example_group "instance methods" do
    describe "#==" do
      subject(:constructor_params) { described_class.new(**params) }

      let(:params) { {args: [:foo], kwargs: {foo: :bar}, block: proc { :foo }} }

      context "when `other` has different class" do
        let(:other) { 42 }

        it "returns false" do
          expect(constructor_params == other).to be_nil
        end
      end

      context "when `other` has different `args`" do
        let(:other) { described_class.new(**params.merge(args: [:baz])) }

        it "returns false" do
          expect(constructor_params == other).to eq(false)
        end
      end

      context "when `other` has different `kwargs`" do
        let(:other) { described_class.new(**params.merge(kwargs: {baz: :qux})) }

        it "returns false" do
          expect(constructor_params == other).to eq(false)
        end
      end

      context "when `other` has different `block`" do
        let(:other) { described_class.new(**params.merge(block: other_block)) }
        let(:other_block) { proc { :baz } }

        it "returns false" do
          expect(constructor_params == other).to eq(false)
        end

        ##
        # TODO: Refactor.
        #
        # rubocop:disable Lint/Void, RSpec/ExampleLength
        it "uses `source_location` to compare blocks" do
          constructor_params_source_location = double
          other_block_source_location = double

          allow(params[:block]).to receive(:source_location).and_return(constructor_params_source_location)
          allow(other_block).to receive(:source_location).and_return(other_block_source_location)
          allow(constructor_params_source_location).to receive(:==).with(other_block_source_location)

          constructor_params == other

          expect(constructor_params_source_location).to have_received(:==)
        end
        # rubocop:enable Lint/Void, RSpec/ExampleLength
      end

      context "when `other` has same attributes" do
        let(:other) { described_class.new(**params) }

        it "returns true" do
          expect(constructor_params == other).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
