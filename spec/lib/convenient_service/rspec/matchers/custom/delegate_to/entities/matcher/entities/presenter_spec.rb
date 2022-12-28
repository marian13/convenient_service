# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Presenter do
  let(:matcher) { ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher.new(object, method, block_expectation) }
  let(:presenter) { described_class.new(matcher: matcher) }

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
  let(:block_expectation) { proc { object.foo } }

  let(:delegation) do
    ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Delegation.new(
      object: object,
      method: method,
      args: args,
      kwargs: kwargs,
      block: block
    )
  end

  let(:arguments) { ConvenientService::Support::Arguments.new(*args, **kwargs, &block) }

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  example_group "instance methods" do
    describe "#printable_method" do
      it "delegates to `ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Presenter::Commands::GeneratePrintableMethod`" do
        allow(ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Presenter::Commands::GeneratePrintableMethod).to receive(:call).with(object: matcher.object, method: matcher.method).and_call_original

        presenter.printable_method

        expect(ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Presenter::Commands::GeneratePrintableMethod).to have_received(:call).with(object: matcher.object, method: matcher.method)
      end

      it "returns `ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Presenter::Commands::GeneratePrintableMethod` value" do
        expect(presenter.printable_method).to eq(ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Presenter::Commands::GeneratePrintableMethod.call(object: matcher.object, method: matcher.method))
      end

      it "caches its value" do
        expect(presenter.printable_method.object_id).to eq(presenter.printable_method.object_id)
      end
    end

    describe "#printable_block_expectation" do
      it "delegates to `ConvenientService::Utils::Proc.display`" do
        allow(ConvenientService::Utils::Proc).to receive(:display).with(matcher.block_expectation).and_call_original

        presenter.printable_block_expectation

        expect(ConvenientService::Utils::Proc).to have_received(:display).with(matcher.block_expectation)
      end

      it "returns `ConvenientService::Utils::Proc` value" do
        expect(presenter.printable_block_expectation).to eq(ConvenientService::Utils::Proc.display(matcher.block_expectation))
      end

      it "caches its value" do
        expect(presenter.printable_block_expectation.object_id).to eq(presenter.printable_block_expectation.object_id)
      end
    end

    example_group "comparison" do
      describe "#==" do
        let(:presenter) { described_class.new(matcher: matcher) }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `false`" do
            expect(presenter == other).to be_nil
          end
        end

        context "when `other` has different `matcher`" do
          let(:other) { described_class.new(matcher: double) }

          it "returns `false`" do
            expect(presenter == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(matcher: ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher.new(object, method, block_expectation)) }

          it "returns `true`" do
            expect(presenter == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
