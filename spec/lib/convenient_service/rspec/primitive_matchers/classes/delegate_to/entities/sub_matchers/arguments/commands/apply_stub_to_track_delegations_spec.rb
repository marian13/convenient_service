# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::SubMatchers::Arguments::Commands::ApplyStubToTrackDelegations do
  subject(:command_result) { described_class.call(matcher: matcher) }

  let(:matcher) { ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo.new(object, method).with_calling_original }

  let(:klass) do
    Class.new do
      def foo(...)
        bar(...)
      end

      def bar(...)
        baz(...)
      end

      def baz(...)
        "baz value"
      end
    end
  end

  let(:object) { klass.new }
  let(:method) { :bar }

  let(:delegation) do
    ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::Delegation.new(
      object: object,
      method: method,
      args: args,
      kwargs: kwargs,
      block: block
    )
  end

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  example_group "modules" do
    include ConvenientService::RSpec::PrimitiveMatchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(RSpec::Mocks::ExampleMethods) }
  end

  example_group "class methods" do
    describe ".call" do
      before do
        command_result
      end

      context "when block expectation does NOT delegate" do
        let(:block_expectation) { proc {} }
        let(:delegations) { [] }

        it "does NOT add any delegation to matcher" do
          block_expectation.call

          expect(matcher.delegations).to eq(delegations)
        end
      end

      context "when block expectation delegates once" do
        let(:block_expectation) { proc { object.foo(*args, **kwargs, &block) } }
        let(:delegations) { [delegation] }

        it "adds that one delegation to matcher" do
          block_expectation.call

          expect(matcher.delegations).to eq(delegations)
        end

        it "calls original method once" do
          allow(object).to receive(:baz)

          block_expectation.call

          expect(object).to have_received(:baz).once
        end

        context "when matcher should NOT call original" do
          let(:matcher) { ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo.new(object, method).without_calling_original }

          it "skips calling original method" do
            allow(object).to receive(:baz)

            block_expectation.call

            expect(object).not_to have_received(:baz)
          end
        end
      end

      context "when block expectation delegates multiple times (n times)" do
        let(:block_expectation) { proc { 2.times { object.foo(*args, **kwargs, &block) } } }
        let(:delegations) { [delegation] * 2 }

        it "adds all those delegations to matcher" do
          block_expectation.call

          expect(matcher.delegations).to eq(delegations)
        end

        it "calls original method n times" do
          allow(object).to receive(:baz)

          block_expectation.call

          expect(object).to have_received(:baz).twice
        end

        context "when matcher should NOT call original" do
          let(:matcher) { ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo.new(object, method).without_calling_original }

          it "skips calling original method" do
            allow(object).to receive(:baz)

            block_expectation.call

            expect(object).not_to have_received(:baz)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
