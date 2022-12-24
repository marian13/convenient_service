# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Delegation do
  let(:delegation) { described_class.new(object: object, method: method, args: args, kwargs: kwargs, block: block) }

  let(:klass) do
    Class.new do
      def foo
        bar
      end

      def bar
        "bar value"
      end
    end
  end

  let(:object) { klass.new }
  let(:method) { :bar }

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { delegation }

    it { is_expected.to have_attr_reader(:object) }
    it { is_expected.to have_attr_reader(:method) }
    it { is_expected.to have_attr_reader(:arguments) }
  end

  example_group "class methods" do
    describe "#new" do
      let(:delegation) { described_class.new(object: object, method: method, args: args, kwargs: kwargs, block: block) }

      it "assigns arguments" do
        expect(delegation.arguments).to eq(ConvenientService::Support::Arguments.new(*args, **kwargs, &block))
      end
    end
  end

  example_group "instance methods" do
    describe "#with_arguments?" do
      context "when delegation has at least one arg" do
        let(:delegation) { described_class.new(object: object, method: method, args: args, kwargs: {}, block: nil) }

        it "returns `true`" do
          expect(delegation.with_arguments?).to eq(true)
        end
      end

      context "when delegation has at least one kwarg" do
        let(:delegation) { described_class.new(object: object, method: method, args: [], kwargs: kwargs, block: nil) }

        it "returns `true`" do
          expect(delegation.with_arguments?).to eq(true)
        end
      end

      context "when delegation has at block" do
        let(:delegation) { described_class.new(object: object, method: method, args: [], kwargs: {}, block: block) }

        it "returns `true`" do
          expect(delegation.with_arguments?).to eq(true)
        end
      end

      context "when delegation does NOT have args, kwargs and block" do
        let(:delegation) { described_class.new(object: object, method: method, args: [], kwargs: {}, block: nil) }

        it "returns `false`" do
          expect(delegation.with_arguments?).to eq(false)
        end
      end
    end

    describe "#without_arguments?" do
      context "when delegation has at least one arg" do
        let(:delegation) { described_class.new(object: object, method: method, args: args, kwargs: {}, block: nil) }

        it "returns `false`" do
          expect(delegation.without_arguments?).to eq(false)
        end
      end

      context "when delegation has at least one kwarg" do
        let(:delegation) { described_class.new(object: object, method: method, args: [], kwargs: kwargs, block: nil) }

        it "returns `false`" do
          expect(delegation.without_arguments?).to eq(false)
        end
      end

      context "when delegation has at block" do
        let(:delegation) { described_class.new(object: object, method: method, args: [], kwargs: {}, block: block) }

        it "returns `false`" do
          expect(delegation.without_arguments?).to eq(false)
        end
      end

      context "when delegation does NOT have args, kwargs and block" do
        let(:delegation) { described_class.new(object: object, method: method, args: [], kwargs: {}, block: nil) }

        it "returns `true`" do
          expect(delegation.without_arguments?).to eq(true)
        end
      end
    end

    describe "#==" do
      subject(:delegation) { described_class.new(object: object, method: method, args: args, kwargs: kwargs, block: block) }

      context "when `other` has different class" do
        let(:other) { 42 }

        it "returns `false`" do
          expect(delegation == other).to be_nil
        end
      end

      context "when `other` has different `object`" do
        let(:other) { described_class.new(object: Object.new, method: method, args: args, kwargs: kwargs, block: block) }

        it "returns `false`" do
          expect(delegation == other).to eq(false)
        end
      end

      context "when `other` has different `method`" do
        let(:other) { described_class.new(object: object, method: :qux, args: args, kwargs: kwargs, block: block) }

        it "returns `false`" do
          expect(delegation == other).to eq(false)
        end
      end

      context "when `other` has different `args`" do
        let(:other) { described_class.new(object: object, method: method, args: [], kwargs: kwargs, block: block) }

        it "returns `false`" do
          expect(delegation == other).to eq(false)
        end
      end

      context "when `other` has different `kwargs`" do
        let(:other) { described_class.new(object: object, method: method, args: args, kwargs: {}, block: block) }

        it "returns `false`" do
          expect(delegation == other).to eq(false)
        end
      end

      context "when `other` has different `block`" do
        let(:other) { described_class.new(object: object, method: method, args: args, kwargs: kwargs, block: nil) }

        it "returns `false`" do
          expect(delegation == other).to eq(false)
        end
      end

      context "when `other` has same attributes" do
        let(:other) { described_class.new(object: object, method: method, args: args, kwargs: kwargs, block: block) }

        it "returns `true`" do
          expect(delegation == other).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
