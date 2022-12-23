# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Presenter do
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

  example_group "instance methods" do
    describe "#printable_method" do
      it "delegates to `ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Presenter::Commands::GeneratePrintableMethod`" do
        allow(ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Presenter::Commands::GeneratePrintableMethod).to receive(:call).with(object: matcher.object, method: matcher.method).and_call_original

        presenter.printable_method

        expect(ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Presenter::Commands::GeneratePrintableMethod).to have_received(:call).with(object: matcher.object, method: matcher.method)
      end

      it "returns `ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Presenter::Commands::GeneratePrintableMethod` value" do
        expect(presenter.printable_method).to eq(ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Presenter::Commands::GeneratePrintableMethod.call(object: matcher.object, method: matcher.method))
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

    describe "#printable_actual_arguments" do
      context "when matcher has NO delegations" do
        let(:printable_arguments) { "" }

        it "returns empty string" do
          expect(presenter.printable_actual_arguments).to eq(printable_arguments)
        end
      end

      context "when matcher has one delegation" do
        let(:printable_arguments) { ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Presenter::Commands::GeneratePrintableArguments.call(arguments: matcher.delegations.first.arguments) }

        before do
          matcher.delegations << ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Delegation.new(args: [:foo], kwargs: {foo: :bar}, block: proc { :foo })
        end

        it "returns printable arguments for that delegation" do
          expect(presenter.printable_actual_arguments).to eq(printable_arguments)
        end
      end

      context "when matcher has multiple delegations" do
        let(:printable_arguments) do
          matcher.delegations
            .map { |delegation| ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Presenter::Commands::GeneratePrintableArguments.call(arguments: delegation.arguments) }
            .join(", ")
        end

        before do
          2.times { matcher.delegations << ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Delegation.new(args: [:foo], kwargs: {foo: :bar}, block: proc { :foo }) }
        end

        it "returns printable arguments concatted by command for those delegations" do
          expect(presenter.printable_actual_arguments).to eq(printable_arguments)
        end
      end
    end

    describe "#generate_printable_arguments" do
      let(:arguments) { ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Arguments.new(args: [:foo], kwargs: {foo: :bar}, block: proc { :foo }) }

      it "delegates to `ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Presenter::Commands::GeneratePrintableArguments`" do
        allow(ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Presenter::Commands::GeneratePrintableArguments).to receive(:call).with(arguments: arguments).and_call_original

        presenter.generate_printable_arguments(arguments)

        expect(ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Presenter::Commands::GeneratePrintableArguments).to have_received(:call).with(arguments: arguments)
      end

      it "returns `ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Presenter::Commands::GeneratePrintableArguments` value" do
        expect(presenter.generate_printable_arguments(arguments)).to eq(ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Presenter::Commands::GeneratePrintableArguments.call(arguments: arguments))
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
