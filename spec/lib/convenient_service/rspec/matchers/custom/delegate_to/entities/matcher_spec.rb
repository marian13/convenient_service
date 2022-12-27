# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

##
# NOTE: This class is tested in behavior style, imagining having no knowledge about implementation.
# NOTE: Do not forget to check coverage when modifying source.
#
# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, Style/Semicolon
RSpec.describe ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher do
  subject(:matcher_result) { matcher.matches?(block_expectation) }

  let(:matcher) { described_class.new(object, method) }

  let(:klass) do
    Class.new do
      def foo(...)
        bar(...)
      end

      def bar(...)
        "bar value"
      end
    end
  end

  let(:object) { klass.new }
  let(:method) { :bar }

  let(:block_expectation) { proc { object.foo } }
  let(:printable_method) { "#{klass}##{method}" }

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

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
        let(:matcher) { described_class.new(object, method) }

        ##
        # NOTE: `expect {}.to delegate_to(object, :bar)`
        #
        context "when `block_expectation` does NOT delegate" do
          let(:block_expectation) { proc {} }

          it "returns `false`" do
            expect(matcher_result).to eq(false)
          end
        end

        context "when `block_expectation` delegates once" do
          ##
          # NOTE: `expect { object.foo }.to delegate_to(object, :bar)`
          #
          context "when `block_expectation` delegates once without arguments" do
            let(:block_expectation) { proc { object.foo } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end

          ##
          # NOTE: `expect { object.foo(*args) }.to delegate_to(object, :bar)`
          #
          context "when `block_expectation` delegates once with any arguments" do
            let(:block_expectation) { proc { object.foo(*args) } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end
        end

        context "when `block_expectation` delegates multiple times" do
          ##
          # NOTE: `expect { 3.times { object.foo } }.to delegate_to(object, :bar)`
          #
          context "when `block_expectation` delegates all times without arguments" do
            let(:block_expectation) { proc { 3.times { object.foo } } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end

          ##
          # NOTE: `expect { object.foo; object.foo(*kwargs); object.foo(&block) } }.to delegate_to(object, :bar)`
          #
          context "when `block_expectation` delegates some times with arguments" do
            let(:block_expectation) { proc { object.foo; object.foo(*kwargs); object.foo(&block) } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end

          ##
          # NOTE: `expect { 3.times { object.foo(*args, **kwargs, &block) } }.to delegate_to(object, :bar)`
          #
          context "when `block_expectation` delegates all times with arguments" do
            let(:block_expectation) { proc { 3.times { object.foo(*args, **kwargs, &block) } } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end
        end
      end

      context "when used with `without_arguments`" do
        let(:matcher) { described_class.new(object, method).without_arguments }

        ##
        # NOTE: `expect {}.to delegate_to(object, :bar).without_arguments`
        #
        context "when `block_expectation` does NOT delegate" do
          let(:block_expectation) { proc {} }

          it "returns `false`" do
            expect(matcher_result).to eq(false)
          end
        end

        context "when `block_expectation` delegates once" do
          ##
          # NOTE: `expect { object.foo }.to delegate_to(object, :bar).without_arguments`
          #
          context "when `block_expectation` delegates once without arguments" do
            let(:block_expectation) { proc { object.foo } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end

          ##
          # NOTE: `expect { object.foo(*args) }.to delegate_to(object, :bar).without_arguments`
          #
          context "when `block_expectation` delegates once with any arguments" do
            let(:block_expectation) { proc { object.foo(*args) } }

            it "returns `false`" do
              expect(matcher_result).to eq(false)
            end
          end
        end

        context "when `block_expectation` delegates multiple times" do
          ##
          # NOTE: `expect { 3.times { object.foo } }.to delegate_to(object, :bar).without_arguments`
          #
          context "when `block_expectation` delegates all times without arguments" do
            let(:block_expectation) { proc { 3.times { object.foo } } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end

          ##
          # NOTE: `expect { object.foo; object.foo(*kwargs); object.foo(&block) } }.to delegate_to(object, :bar).without_arguments`
          #
          context "when `block_expectation` delegates some times with arguments" do
            let(:block_expectation) { proc { object.foo; object.foo(*kwargs); object.foo(&block) } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end

          ##
          # NOTE: `expect { 3.times { object.foo(*args, **kwargs, &block) } }.to delegate_to(object, :bar).without_arguments`
          #
          context "when `block_expectation` delegates all times with arguments" do
            let(:block_expectation) { proc { 3.times { object.foo(*args, **kwargs, &block) } } }

            it "returns `false`" do
              expect(matcher_result).to eq(false)
            end
          end
        end
      end

      context "when used with `with_any_arguments`" do
        let(:matcher) { described_class.new(object, method).with_any_arguments }

        ##
        # NOTE: `expect {}.to delegate_to(object, :bar).with_any_arguments`
        #
        context "when `block_expectation` does NOT delegate" do
          let(:block_expectation) { proc {} }

          it "returns `false`" do
            expect(matcher_result).to eq(false)
          end
        end

        context "when `block_expectation` delegates once" do
          ##
          # NOTE: `expect { object.foo }.to delegate_to(object, :bar).with_any_arguments`
          #
          context "when `block_expectation` delegates once without arguments" do
            let(:block_expectation) { proc { object.foo } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end

          ##
          # NOTE: `expect { object.foo(*args) }.to delegate_to(object, :bar).with_any_arguments`
          #
          context "when `block_expectation` delegates once with any arguments" do
            let(:block_expectation) { proc { object.foo(*args) } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end
        end

        context "when `block_expectation` delegates multiple times" do
          ##
          # NOTE: `expect { 3.times { object.foo } }.to delegate_to(object, :bar).with_any_arguments`
          #
          context "when `block_expectation` delegates all times without arguments" do
            let(:block_expectation) { proc { 3.times { object.foo } } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end

          ##
          # NOTE: `expect { object.foo; object.foo(*kwargs); object.foo(&block) } }.to delegate_to(object, :bar).with_any_arguments`
          #
          context "when `block_expectation` delegates some times with arguments" do
            let(:block_expectation) { proc { object.foo; object.foo(*kwargs); object.foo(&block) } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end

          ##
          # NOTE: `expect { 3.times { object.foo(*args, **kwargs, &block) } }.to delegate_to(object, :bar).with_any_arguments`
          #
          context "when `block_expectation` delegates all times with arguments" do
            let(:block_expectation) { proc { 3.times { object.foo(*args, **kwargs, &block) } } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end
        end
      end

      context "when used with `with_arguments(*args, **kwargs, &block)` (concrete arguments)" do
        let(:matcher) { described_class.new(object, method).with_arguments(*args, **kwargs, &block) }

        ##
        # NOTE: `expect {}.to delegate_to(object, :bar).with_arguments(*args, **kwargs, &block)`
        #
        context "when `block_expectation` does NOT delegate" do
          let(:block_expectation) { proc {} }

          it "returns `false`" do
            expect(matcher_result).to eq(false)
          end
        end

        context "when `block_expectation` delegates once" do
          ##
          # NOTE: `expect { object.foo }.to delegate_to(object, :bar).with_arguments(*args, **kwargs, &block)`
          #
          context "when `block_expectation` delegates once without arguments" do
            let(:block_expectation) { proc { object.foo } }

            it "returns `false`" do
              expect(matcher_result).to eq(false)
            end
          end

          ##
          # NOTE: `expect { object.foo(*args) }.to delegate_to(object, :bar).with_arguments(*args, **kwargs, &block)`
          #
          context "when `block_expectation` delegates once with any arguments" do
            let(:block_expectation) { proc { object.foo(*args) } }

            it "returns `false`" do
              expect(matcher_result).to eq(false)
            end
          end

          ##
          # NOTE: `expect { object.foo(*args, **kwargs, &block) }.to delegate_to(object, :bar).with_arguments(*args, **kwargs, &block)`
          #
          context "when `block_expectation` delegates once with concrete arguments" do
            let(:block_expectation) { proc { object.foo(*args, **kwargs, &block) } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end
        end

        context "when `block_expectation` delegates multiple times" do
          ##
          # NOTE: `expect { 3.times { object.foo } }.to delegate_to(object, :bar).with_arguments(*args, **kwargs, &block)`
          #
          context "when `block_expectation` delegates all times without arguments" do
            let(:block_expectation) { proc { 3.times { object.foo } } }

            it "returns `false`" do
              expect(matcher_result).to eq(false)
            end
          end

          ##
          # NOTE: `expect { object.foo; object.foo(*kwargs); object.foo(&block) } }.to delegate_to(object, :bar).with_arguments(*args, **kwargs, &block)`
          #
          context "when `block_expectation` delegates some times with any arguments" do
            let(:block_expectation) { proc { object.foo; object.foo(*kwargs); object.foo(&block) } }

            it "returns `false`" do
              expect(matcher_result).to eq(false)
            end
          end

          ##
          # NOTE: `expect { object.foo; object.foo(*args, **kwargs, &block); object.foo(&block) } }.to delegate_to(object, :bar).with_arguments(*args, **kwargs, &block)`
          #
          context "when `block_expectation` delegates some times with concrete arguments" do
            let(:block_expectation) { proc { object.foo; object.foo(*args, **kwargs, &block); object.foo(&block) } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end

          ##
          # NOTE: `expect { 3.times { object.foo(*args, **kwargs) } }.to delegate_to(object, :bar).with_arguments(*args, **kwargs, &block)`
          #
          context "when `block_expectation` delegates all times with any arguments" do
            let(:block_expectation) { proc { 3.times { object.foo(*args, **kwargs) } } }

            it "returns `false`" do
              expect(matcher_result).to eq(false)
            end
          end

          ##
          # NOTE: `expect { 3.times { object.foo(*args, **kwargs, &block) } }.to delegate_to(object, :bar).with_arguments(*args, **kwargs, &block)`
          #
          context "when `block_expectation` delegates all times with concrete arguments" do
            let(:block_expectation) { proc { 3.times { object.foo(*args, **kwargs, &block) } } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end
        end
      end

      context "when used with `and_return_its_value`" do
        let(:matcher) { described_class.new(object, method).and_return_its_value }

        ##
        # NOTE: `expect { object.foo }.to delegate_to(object, :bar).and_return_its_value`
        #
        context "when `block_expectation` does NOT delegate" do
          let(:block_expectation) { proc {} }

          it "returns `false`" do
            expect(matcher_result).to eq(false)
          end
        end

        context "when `block_expectation` delegates once" do
          ##
          # NOTE: `expect { object.foo; 42 }.to delegate_to(object, :bar).and_return_its_value`
          #
          context "when `block_expectation` does NOT return delegation value" do
            let(:block_expectation) { proc { object.foo; 42 } }

            it "returns `false`" do
              expect(matcher_result).to eq(false)
            end
          end

          ##
          # NOTE: `expect { object.foo }.to delegate_to(object, :bar).and_return_its_value`
          #
          context "when `block_expectation` returns delegation value" do
            let(:block_expectation) { proc { object.foo } }

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end
          end
        end

        context "when `block_expectation` delegates multiple times" do
          ##
          # NOTE: `expect { object.foo; object.foo; 42 }.to delegate_to(object, :bar).and_return_its_value`
          #
          context "when `block_expectation` does NOT return delegation value" do
            let(:block_expectation) { proc { object.foo; object.foo; 42 } }

            it "returns `false`" do
              expect(matcher_result).to eq(false)
            end
          end

          ##
          # NOTE: `expect { object.foo; object.foo; object.foo }.to delegate_to(object, :bar).and_return_its_value`
          #
          context "when `block_expectation` returns delegation value" do
            let(:block_expectation) { proc { object.foo; object.foo; object.foo } }

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
      it "returns chainings failure message" do
        expect(matcher.failure_message).to eq(matcher.chainings.failure_message)
      end
    end

    describe "#failure_message_when_negated" do
      it "returns chainings failure message when negated" do
        expect(matcher.failure_message_when_negated).to eq(matcher.chainings.failure_message_when_negated)
      end
    end

    describe "#with_arguments" do
      it "returns matcher" do
        expect(matcher.with_arguments).to eq(matcher)
      end
    end

    describe "#with_any_arguments" do
      it "returns matcher" do
        expect(matcher.with_any_arguments).to eq(matcher)
      end
    end

    describe "#without_arguments" do
      it "returns matcher" do
        expect(matcher.without_arguments).to eq(matcher)
      end
    end

    describe "#and_return_its_value" do
      it "returns matcher" do
        expect(matcher.and_return_its_value).to eq(matcher)
      end
    end

    describe "#with_calling_original" do
      it "returns matcher" do
        expect(matcher.with_calling_original).to eq(matcher)
      end
    end

    describe "#without_calling_original" do
      it "returns matcher" do
        expect(matcher.without_calling_original).to eq(matcher)
      end
    end

    example_group "comparison" do
      describe "#==" do
        let(:matcher) { described_class.new(object, method, block_expectation) }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `false`" do
            expect(matcher == other).to be_nil
          end
        end

        context "when `other` has different `object`" do
          let(:other) { described_class.new(Object.new, method, block_expectation) }

          it "returns `false`" do
            expect(matcher == other).to eq(false)
          end
        end

        context "when `other` has different `method`" do
          let(:other) { described_class.new(object, :qux, block_expectation) }

          it "returns `false`" do
            expect(matcher == other).to eq(false)
          end
        end

        context "when `other` has different `block_expectation`" do
          let(:other) { described_class.new(object, method, proc { :qux }) }

          it "returns `false`" do
            expect(matcher == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(object, method, block_expectation) }

          it "returns `true`" do
            expect(matcher == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, Style/Semicolon
