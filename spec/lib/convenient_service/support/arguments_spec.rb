# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::Arguments do
  let(:arguments) { described_class.new(*args, **kwargs, &block) }

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { arguments }

    it { is_expected.to have_attr_reader(:args) }
    it { is_expected.to have_attr_reader(:kwargs) }
    it { is_expected.to have_attr_reader(:block) }
  end

  example_group "class methods" do
    describe "#new" do
      context "when args are NOT passed" do
        let(:arguments) { described_class.new(**kwargs, &block) }

        it "defaults to empty array" do
          expect(arguments.args).to eq([])
        end
      end

      context "when kwargs are NOT passed" do
        let(:arguments) { described_class.new(*args, &block) }

        it "defaults to empty hash" do
          expect(arguments.kwargs).to eq({})
        end
      end

      context "when block are NOT passed" do
        let(:arguments) { described_class.new(*args, **kwargs) }

        it "defaults to `nil`" do
          expect(arguments.block).to be_nil
        end
      end
    end
  end

  example_group "instance methods" do
    describe "#null_arguments?" do
      it "returns `false`" do
        expect(arguments.null_arguments?).to eq(false)
      end
    end

    describe "#==" do
      subject(:arguments) { described_class.new(*args, **kwargs, &block) }

      context "when `other` has different class" do
        let(:other) { 42 }

        it "returns `false`" do
          expect(arguments == other).to be_nil
        end
      end

      context "when `other` has different `args`" do
        let(:other) { described_class.new(:bar, **kwargs, &block) }

        it "returns `false`" do
          expect(arguments == other).to eq(false)
        end
      end

      context "when `other` has different `kwargs`" do
        let(:other) { described_class.new(*args, {bar: :baz}, &block) }

        it "returns `false`" do
          expect(arguments == other).to eq(false)
        end
      end

      context "when `other` has different `block`" do
        let(:other) { described_class.new(*args, **kwargs, &other_block) }
        let(:other_block) { proc { :bar } }

        it "returns `false`" do
          expect(arguments == other).to eq(false)
        end
      end

      context "when `other` has same attributes" do
        let(:other) { described_class.new(*args, **kwargs, &block) }

        it "returns `true`" do
          expect(arguments == other).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
