# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::SubMatchers::WithConcreteArguments, type: :standard do
  let(:sub_matcher) { described_class.new(matcher: matcher) }

  let(:matcher) { ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo.new(object, method) }

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
  let(:block_expectation_value) { block_expectation.call }

  let(:expected_arguments) { ConvenientService::Support::Arguments.new(*args, **kwargs, &block) }

  let(:delegation_with_expected_arguments) do
    ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::Delegation.new(
      object: object,
      method: method,
      args: args,
      kwargs: kwargs,
      block: block
    )
  end

  let(:delegation_with_not_expected_arguments) do
    ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::Delegation.new(
      object: object,
      method: method,
      args: [:bar],
      kwargs: {bar: :baz},
      block: proc { :bar }
    )
  end

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::SubMatchers::Arguments) }
  end

  example_group "instance methods" do
    ##
    # NOTE: Tests `matches_arguments?`.
    #
    describe "#matches?" do
      context "when matcher expected arguments are NOT set" do
        ##
        # NOTE: If it calls `super` then block_expectation_value is set.
        #
        it "calls `super`" do
          sub_matcher.matches?(block_expectation_value)

          expect(sub_matcher.block_expectation_value).to eq(block_expectation_value)
        end

        it "returns `false`" do
          expect(sub_matcher.matches?(block_expectation_value)).to eq(false)
        end
      end

      context "when matcher expected arguments are set" do
        before do
          matcher.inputs.expected_arguments = expected_arguments
        end

        ##
        # NOTE: If it calls `super` then block_expectation_value is set.
        #
        it "calls `super`" do
          sub_matcher.matches?(block_expectation_value)

          expect(sub_matcher.block_expectation_value).to eq(block_expectation_value)
        end

        context "when matcher has NO delegations" do
          before do
            matcher.outputs.delegations.clear
          end

          it "returns `false`" do
            expect(sub_matcher.matches?(block_expectation_value)).to eq(false)
          end
        end

        context "when matcher has one delegation" do
          context "when that one delegation has NOT expected arguments" do
            before do
              matcher.outputs.delegations << delegation_with_not_expected_arguments
            end

            it "returns `false`" do
              expect(sub_matcher.matches?(block_expectation_value)).to eq(false)
            end
          end

          context "when that one delegation has expected arguments" do
            before do
              matcher.outputs.delegations << delegation_with_expected_arguments
            end

            it "returns `true`" do
              expect(sub_matcher.matches?(block_expectation_value)).to eq(true)
            end
          end
        end

        context "when matcher has multiple delegations" do
          context "when all those multiple delegations have NOT expected arguments" do
            before do
              2.times { matcher.outputs.delegations << delegation_with_not_expected_arguments }
            end

            it "returns `false`" do
              expect(sub_matcher.matches?(block_expectation_value)).to eq(false)
            end
          end

          context "when any of those multiple delegations has expected arguments" do
            before do
              matcher.outputs.delegations << delegation_with_not_expected_arguments

              matcher.outputs.delegations << delegation_with_expected_arguments
            end

            it "returns `true`" do
              expect(sub_matcher.matches?(block_expectation_value)).to eq(true)
            end
          end
        end
      end
    end

    describe "#printable_expected_arguments" do
      let(:printable_expected_arguments) { "with `#{ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::SubMatchers::Arguments::Commands::GeneratePrintableArguments.call(arguments: expected_arguments)}`" }

      before do
        matcher.inputs.expected_arguments = expected_arguments
      end

      it "returns printable expected arguments" do
        expect(sub_matcher.printable_expected_arguments).to eq(printable_expected_arguments)
      end

      it "delegates to `ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::SubMatchers::Arguments::Commands::GeneratePrintableArguments`" do
        allow(ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::SubMatchers::Arguments::Commands::GeneratePrintableArguments).to receive(:call).with(arguments: expected_arguments).and_call_original

        sub_matcher.printable_expected_arguments

        expect(ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::SubMatchers::Arguments::Commands::GeneratePrintableArguments).to have_received(:call).with(arguments: expected_arguments)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
