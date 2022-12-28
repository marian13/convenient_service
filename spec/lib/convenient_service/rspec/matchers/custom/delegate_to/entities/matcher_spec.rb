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
      it "sets `ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::Matchers::WithConcreteArguments` instance as argument chaining" do
        matcher.with_arguments

        expect(matcher.chainings.arguments).to be_instance_of(ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::Matchers::WithConcreteArguments)
      end

      it "returns matcher" do
        expect(matcher.with_arguments).to eq(matcher)
      end
    end

    describe "#with_any_arguments" do
      it "sets `ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::Matchers::WithAnyArguments` instance as argument chaining" do
        matcher.with_any_arguments

        expect(matcher.chainings.arguments).to be_instance_of(ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::Matchers::WithAnyArguments)
      end

      it "returns matcher" do
        expect(matcher.with_any_arguments).to eq(matcher)
      end
    end

    describe "#without_arguments" do
      it "sets `ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::Matchers::WithoutArguments` instance as argument chaining" do
        matcher.without_arguments

        expect(matcher.chainings.arguments).to be_instance_of(ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::Matchers::WithoutArguments)
      end

      it "returns matcher" do
        expect(matcher.without_arguments).to eq(matcher)
      end
    end

    describe "#and_return_its_value" do
      it "sets `ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::Matchers::ReturnItsValue` instance as argument chaining" do
        matcher.and_return_its_value

        expect(matcher.chainings.return_its_value).to be_instance_of(ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::Matchers::ReturnItsValue)
      end

      it "returns matcher" do
        expect(matcher.and_return_its_value).to eq(matcher)
      end
    end

    describe "#with_calling_original" do
      it "sets `ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::Permissions::WithCallingOriginal` instance as call original chaining" do
        matcher.with_calling_original

        expect(matcher.chainings.call_original).to be_instance_of(ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::Permissions::WithCallingOriginal)
      end

      it "returns matcher" do
        expect(matcher.with_calling_original).to eq(matcher)
      end
    end

    describe "#without_calling_original" do
      it "sets `ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::Permissions::WithoutCallingOriginal` instance as call original chaining" do
        matcher.without_calling_original

        expect(matcher.chainings.call_original).to be_instance_of(ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::Permissions::WithoutCallingOriginal)
      end

      it "returns matcher" do
        expect(matcher.without_calling_original).to eq(matcher)
      end
    end

    describe "#delegation_value" do
      it "delegates to `ConvenientService::Utils::Object`" do
        allow(ConvenientService::Utils::Object).to receive(:instance_variable_fetch).with(matcher, :@delegation_value).and_call_original

        matcher.delegation_value

        expect(ConvenientService::Utils::Object).to have_received(:instance_variable_fetch).with(matcher, :@delegation_value)
      end

      it "returns to `object.send`" do
        expect(matcher.delegation_value).to eq(object.__send__(matcher.method, *matcher.expected_arguments.args, **matcher.expected_arguments.kwargs, &matcher.expected_arguments.block))
      end
    end

    describe "#expected_arguments=" do
      let(:arguments) { ConvenientService::Support::Arguments.new }

      it "sets expected arguments" do
        matcher.expected_arguments = arguments

        expect(matcher.expected_arguments).to eq(arguments)
      end

      it "returns expected arguments" do
        expect(matcher.expected_arguments = arguments).to eq(arguments)
      end

      it "delegates to `ConvenientService::Utils::Object`" do
        allow(ConvenientService::Utils::Object).to receive(:instance_variable_delete).with(matcher, :@delegation_value).and_call_original

        matcher.expected_arguments = arguments

        expect(ConvenientService::Utils::Object).to have_received(:instance_variable_delete).with(matcher, :@delegation_value)
      end
    end

    describe "#printable_method" do
      it "delegates to `ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Commands::GeneratePrintableMethod`" do
        allow(ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Commands::GeneratePrintableMethod).to receive(:call).with(object: matcher.object, method: matcher.method).and_call_original

        presenter.printable_method

        expect(ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Commands::GeneratePrintableMethod).to have_received(:call).with(object: matcher.object, method: matcher.method)
      end

      it "returns `ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Commands::GeneratePrintableMethod` value" do
        expect(presenter.printable_method).to eq(ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Commands::GeneratePrintableMethod.call(object: matcher.object, method: matcher.method))
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
