# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::Matcher::Entities::Chainings::SubMatchers::WithoutArguments do
  let(:chaining) { described_class.new(matcher: matcher) }

  let(:matcher) { ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::Matcher.new(object, method) }

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

  let(:without_arguments) { ConvenientService::Support::Arguments.new }

  let(:delegation_with_arguments) do
    ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::Matcher::Entities::Delegation.new(
      object: object,
      method: method,
      args: args,
      kwargs: kwargs,
      block: block
    )
  end

  let(:delegation_without_arguments) do
    ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::Matcher::Entities::Delegation.new(
      object: object,
      method: method,
      args: [],
      kwargs: {},
      block: nil
    )
  end

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::Matcher::Entities::Chainings::SubMatchers::Arguments) }
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
          chaining.matches?(block_expectation_value)

          expect(chaining.block_expectation_value).to eq(block_expectation_value)
        end

        it "returns `false`" do
          expect(chaining.matches?(block_expectation_value)).to eq(false)
        end
      end

      context "when matcher expected arguments are set" do
        before do
          matcher.expected_arguments = without_arguments
        end

        ##
        # NOTE: If it calls `super` then block_expectation_value is set.
        #
        it "calls `super`" do
          chaining.matches?(block_expectation_value)

          expect(chaining.block_expectation_value).to eq(block_expectation_value)
        end

        context "when matcher has NO delegations" do
          before do
            matcher.delegations.clear
          end

          it "returns `false`" do
            expect(chaining.matches?(block_expectation_value)).to eq(false)
          end
        end

        context "when matcher has one delegation" do
          context "when that one delegation without arguments" do
            before do
              matcher.delegations << delegation_without_arguments
            end

            it "returns `true`" do
              expect(chaining.matches?(block_expectation_value)).to eq(true)
            end
          end

          context "when that one delegation rguments" do
            before do
              matcher.delegations << delegation_with_arguments
            end

            it "returns `false`" do
              expect(chaining.matches?(block_expectation_value)).to eq(false)
            end
          end
        end

        context "when matcher has multiple delegations" do
          context "when any of those multiple delegations without arguments" do
            before do
              matcher.delegations << delegation_with_arguments

              matcher.delegations << delegation_without_arguments
            end

            it "returns `true`" do
              expect(chaining.matches?(block_expectation_value)).to eq(true)
            end
          end

          context "when all those multiple delegations have arguments" do
            before do
              2.times { matcher.delegations << delegation_with_arguments }
            end

            it "returns `false`" do
              expect(chaining.matches?(block_expectation_value)).to eq(false)
            end
          end
        end
      end
    end

    describe "#printable_expected_arguments?" do
      let(:printable_expected_arguments) { "without arguments" }

      it "returns `true`" do
        expect(chaining.printable_expected_arguments).to eq(printable_expected_arguments)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
