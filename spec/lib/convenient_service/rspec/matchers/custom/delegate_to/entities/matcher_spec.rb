# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

##
# TODO: Refactor `delegate_to` to NOT use `expect` internally. Then rewrite this spec file completely.
# IMPORTANT: Make sure you have specs when `block_expectation` does NOT delegate at all, delegates once, delegates multiple times.
#
# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher do
  subject(:matcher_result) { matcher.matches?(block_expectation) }

  let(:matcher) { described_class.new(object, method) }

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
  let(:printable_method) { "#{klass}##{method}" }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Delegate) }
  end

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { matcher }

    it { is_expected.to have_attr_reader(:object) }
    it { is_expected.to have_attr_reader(:method) }
    it { is_expected.to have_attr_reader(:block_expectation) }
  end

  example_group "class methods" do
    describe "#new" do
      context "when block expectation is NOT passed" do
        it "defaults to `nil`" do
          expect(matcher.block_expectation).to be_nil
        end
      end
    end
  end

  example_group "instance methods" do
    describe "#matches?" do
      context "when NO chaining is used" do
        ##
        # NOTE: `expect { object.foo }.to delegate_to(object, :bar)`
        #
        let(:matcher) { described_class.new(object, method) }

        context "when `block_expectation` does NOT delegate" do
          let(:block_expectation) { proc {} }

          it "returns `false`" do
            expect(matcher_result).to eq(false)
          end
        end

        context "when `block_expectation` delegates once" do
          let(:block_expectation) { proc { object.foo } }

          it "returns `true`" do
            expect(matcher_result).to eq(true)
          end
        end

        context "when `block_expectation` delegates multiple times" do
          let(:block_expectation) { proc { 3.times { object.foo } } }

          it "returns `true`" do
            expect(matcher_result).to eq(true)
          end
        end
      end

      context "when used with `and_return_its_value`" do
        ##
        # NOTE: `expect { object.foo }.to delegate_to(object, :bar).and_return_its_value`
        #
        let(:matcher) { described_class.new(object, method).and_return_its_value }

        context "when `block_expectation` does NOT delegate" do
          let(:block_expectation) { proc {} }

          it "returns `false`" do
            expect(matcher_result).to eq(false)
          end
        end

        context "when `block_expectation` delegates once" do
          context "when `block_expectation` does NOT return delegation value" do
            let(:block_expectation) do
              proc do
                object.foo

                42
              end
            end

            it "returns `false`" do
              expect(matcher_result).to eq(false)
            end
          end

          context "when `block_expectation` returns delegation value" do
            let(:block_expectation) { proc { object.foo } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end
        end

        context "when `block_expectation` delegates multiple times" do
          context "when `block_expectation` does NOT return delegation value" do
            let(:block_expectation) do
              proc do
                object.foo

                object.foo

                42
              end
            end

            it "returns `false`" do
              expect(matcher_result).to eq(false)
            end
          end

          context "when `block_expectation` returns delegation value" do
            let(:block_expectation) do
              proc do
                object.foo

                object.foo

                object.foo
              end
            end

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end
        end
      end

      context "when used with `without_arguments`" do
        ##
        # NOTE: `expect { object.foo }.to delegate_to(object, :bar)`
        #
        let(:matcher) { described_class.new(object, method).without_arguments }

        context "when `block_expectation` does NOT delegate" do
          let(:block_expectation) { proc {} }

          it "returns `false`" do
            expect(matcher_result).to eq(false)
          end
        end

        context "when `block_expectation` delegates once" do
          let(:block_expectation) { proc { object.foo } }

          it "returns `true`" do
            expect(matcher_result).to eq(true)
          end
        end

        context "when `block_expectation` delegates multiple times" do
          let(:block_expectation) { proc { 3.times { object.foo } } }

          it "returns `true`" do
            expect(matcher_result).to eq(true)
          end
        end
      end

      context "when used with `with_arguments(*args, **kwargs, &block)`" do
        ##
        # NOTE: `expect { object.foo }.to delegate_to(object, :bar).with_arguments(*args, **kwargs, &block)`
        #
        let(:matcher) { described_class.new(object, method).with_arguments(*args, **kwargs, &block) }

        let(:block_expectation) { proc { object.foo(*args, **kwargs, &block) } }

        let(:klass) do
          Class.new do
            def foo(...)
              bar(...)
            end

            def bar(*args, **kwargs, &block)
              [args, kwargs, block]
            end
          end
        end

        let(:args) { [:foo] }
        let(:kwargs) { {foo: :bar} }
        let(:block) { proc { :foo } }

        context "when `block_expectation` does NOT delegate" do
          let(:block_expectation) { proc {} }

          it "returns `false`" do
            expect(matcher_result).to eq(false)
          end
        end

        context "when `block_expectation` delegates once" do
          context "when `block_expectation` does NOT delegate with specified args" do
            let(:block_expectation) { proc { object.foo(:bar, **kwargs, &block) } }

            it "returns `false`" do
              expect(matcher_result).to eq(false)
            end
          end

          context "when `block_expectation` does NOT delegate with specified kwargs" do
            let(:block_expectation) { proc { object.foo(*args, {bar: :foo}, &block) } }

            it "returns `false`" do
              expect(matcher_result).to eq(false)
            end
          end

          context "when `block_expectation` does NOT delegate with specified block" do
            let(:block_expectation) { proc { object.foo(*args, **kwargs, &proc { :bar }) } }

            it "returns `false`" do
              expect(matcher_result).to eq(false)
            end
          end

          context "when `block_expectation` delegates with specified args, kwargs and block" do
            let(:block_expectation) { proc { object.foo(*args, **kwargs, &block) } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end
        end

        context "when `block_expectation` delegates multiple times" do
          context "when `block_expectation` does NOT delegate with specified args" do
            let(:block_expectation) { proc { object.foo(:bar, **kwargs, &block) } }

            it "returns `false`" do
              expect(matcher_result).to eq(false)
            end
          end

          context "when `block_expectation` does NOT delegate with specified kwargs" do
            let(:block_expectation) { proc { object.foo(*args, {bar: :foo}, &block) } }

            it "returns `false`" do
              expect(matcher_result).to eq(false)
            end
          end

          context "when `block_expectation` does NOT delegate with specified block" do
            let(:block_expectation) { proc { object.foo(*args, **kwargs, &proc { :bar }) } }

            it "returns `false`" do
              expect(matcher_result).to eq(false)
            end
          end

          context "when `block_expectation` delegates with specified args, kwargs and block once" do
            let(:block_expectation) do
              proc do
                object.foo

                object.foo(*args)

                ##
                # NOTE: Comment this line and spec MUST fail.
                #
                object.foo(*args, **kwargs, &block)
              end
            end

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end

          context "when `block_expectation` delegates with specified args, kwargs and block multiple times" do
            let(:block_expectation) do
              proc do
                ##
                # NOTE: Older `delegate_to` implementation were failing with multiple delegations.
                #
                object.foo(*args, **kwargs, &block)

                object.foo(*args, **kwargs, &block)

                object.foo(*args, **kwargs, &block)
              end
            end

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end
        end
      end
    end

    describe "#description" do
      it "returns message" do
        matcher_result

        expect(matcher.description).to eq("delegate to `#{printable_method}`")
      end
    end

    describe "#supports_block_expectations?" do
      it "returns `true`" do
        expect(matcher.supports_block_expectations?).to eq(true)
      end
    end

    ##
    # TODO: Specs.
    #
    # describe "#failure_message" do
    #
    # end

    ##
    # TODO: Specs.
    #
    # describe "#failure_message_when_negated" do
    #
    # end

    describe "#with_arguments" do
      it "returns matcher" do
        expect(matcher.with_arguments).to eq(matcher)
      end
    end

    describe "#and_return_its_value" do
      it "returns matcher" do
        expect(matcher.and_return_its_value).to eq(matcher)
      end
    end

    describe "#without_calling_original" do
      it "returns matcher" do
        expect(matcher.without_calling_original).to eq(matcher)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
