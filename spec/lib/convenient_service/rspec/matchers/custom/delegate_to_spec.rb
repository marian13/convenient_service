# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

##
# TODO: Refactor `delegate_to` to NOT use `expect` internally. Then rewrite this spec file completely.
# IMPORTANT: Make sure you have specs when `block_expectation` does NOT delegate at all, delegates once, delegates multiple times.
#
# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Custom::DelegateTo do
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

  ##
  # NOTE: An example of how RSpec extracts block source, but they marked it as private.
  # https://github.com/rspec/rspec-expectations/blob/311aaf245f2c5493572bf683b8c441cb5f7e44c8/lib/rspec/matchers/built_in/change.rb#L437
  #
  # TODO: `printable_block_expectation` when `method_source` is available.
  # https://github.com/banister/method_source
  #
  # let(:printable_block_expectation) { block_expectation.source }
  #
  let(:printable_block_expectation) { "{ ... }" }

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

    describe "#failure_message" do
      ##
      # TODO: For all chainings.
      #
      context "when used without chaining" do
        let(:matcher) { described_class.new(object, method) }

        it "returns failure message for without chaining" do
          expect(matcher.failure_message).to eq("expected `#{printable_block_expectation}` to delegate to `#{printable_method}` at least once, but it didn't.")
        end
      end

      context "when used with `with_arguments(*args, **kwargs, &block)`" do
        let(:matcher) { described_class.new(object, method).with_arguments(*args, **kwargs, &block) }

        let(:args) { [:foo] }
        let(:kwargs) { {foo: :bar} }
        let(:block) { proc { :foo } }

        it "returns failure message for `with_arguments(*args, **kwargs, &block)`" do
          expect(matcher.failure_message).to eq("expected `#{printable_block_expectation}` to delegate to `#{printable_method}` with `(:foo, foo: :bar) { ... }` at least once, but it didn't.")
        end
      end
    end

    describe "#failure_message_when_negated" do
      ##
      # TODO: For all chainings.
      #
      context "when used without chaining" do
        let(:matcher) { described_class.new(object, method) }

        it "returns failure message when negated for without chaining" do
          expect(matcher.failure_message_when_negated).to eq("expected `#{printable_block_expectation}` NOT to delegate to `#{printable_method}` at least once, but it did.")
        end
      end

      context "when used with `with_arguments(*args, **kwargs, &block)`" do
        let(:matcher) { described_class.new(object, method).with_arguments(*args, **kwargs, &block) }

        let(:args) { [:foo] }
        let(:kwargs) { {foo: :bar} }
        let(:block) { proc { :foo } }

        it "returns failure message when negated for `with_arguments(*args, **kwargs, &block)`" do
          expect(matcher.failure_message_when_negated).to eq("expected `#{printable_block_expectation}` NOT to delegate to `#{printable_method}` with `(:foo, foo: :bar) { ... }` at least once, but it did.")
        end
      end
    end

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
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
