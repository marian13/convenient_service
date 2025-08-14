# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Stateful, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:stack_builder) { described_class.new(name: name, stack: stack) }

  let(:stack) { [] }
  let(:name) { "Stack" }

  let(:args) { [:foo] }
  let(:block) { proc { :foo } }

  example_group "class methods" do
    describe ".new" do
      context "when `name` is NOT passed" do
        it "defaults `\"Stack\"`" do
          expect(stack_builder.name).to eq("Stack")
        end
      end

      context "when `stack` is NOT passed" do
        it "defaults to empty array" do
          expect(stack_builder.stack).to eq([])
        end
      end
    end
  end

  example_group "instance methods" do
    let(:middleware) { proc { :foo } }
    let(:other_middleware) { proc { :bar } }
    let(:index) { 0 }

    example_group "attributes" do
      subject { stack_builder }

      ##
      # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
      #
      it { is_expected.to respond_to(:name) }
      it { is_expected.to respond_to(:stack) }
    end

    describe "#has?" do
      context "when stack does NOT have middleware" do
        before do
          stack_builder.clear
        end

        it "returns `false`" do
          expect(stack_builder.has?(middleware)).to eq(false)
        end
      end

      context "when stack does has middleware" do
        before do
          stack_builder.use(middleware)
        end

        it "returns `true`" do
          expect(stack_builder.has?(middleware)).to eq(true)
        end
      end
    end

    describe "#empty?" do
      specify do
        expect { stack_builder.empty? }
          .to delegate_to(stack, :empty?)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#clear" do
      specify do
        expect { stack_builder.clear }
          .to delegate_to(stack, :clear)
            .without_arguments
            .and_return { stack_builder }
      end
    end

    ##
    # TODO: Comprehensive specs.
    #
    describe "#call" do
      example_group "e2e" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            step :foo
            step :bar
            step :baz

            def foo
              success
            end

            def bar
              success
            end

            def baz
              success
            end
          end
        end

        before do
          stub_const("ConvenientService::Support::Middleware::StackBuilder::Constants::Backends::DEFAULT", ConvenientService::Support::Middleware::StackBuilder::Constants::Backends::STATEFUL)
        end

        it "runs middleware stack" do
          expect(service.result.success?).to eq(true)
        end
      end

      context "when stack is empty" do
        let(:stack) { [] }
        let(:env) { {} }

        it "returns `env`" do
          expect(stack_builder.call(env).object_id).to eq(env.object_id)
        end
      end

      ##
      # TODO: More direct specs.
      ##
    end

    describe "#unshift" do
      specify do
        expect { stack_builder.unshift(middleware) }
          .to delegate_to(stack, :unshift)
            .with_arguments(middleware)
            .and_return { stack_builder }
      end
    end

    describe "#prepend" do
      specify do
        expect { stack_builder.prepend(middleware) }
          .to delegate_to(stack, :unshift)
            .with_arguments(middleware)
            .and_return { stack_builder }
      end
    end

    describe "#use" do
      specify do
        expect { stack_builder.use(middleware) }
          .to delegate_to(stack, :<<)
            .with_arguments(middleware)
            .and_return { stack_builder }
      end
    end

    describe "#append" do
      specify do
        expect { stack_builder.append(middleware) }
          .to delegate_to(stack, :<<)
            .with_arguments(middleware)
            .and_return { stack_builder }
      end
    end

    describe "#insert" do
      context "when `index_or_middleware` is integer" do
        specify do
          expect { stack_builder.insert(index, other_middleware) }
            .to delegate_to(stack, :insert)
              .with_arguments(index, other_middleware)
              .and_return { stack_builder }
        end
      end

      context "when `index_or_middleware` is middleware" do
        context "when that middleware is NOT found in stack" do
          let(:exception_message) do
            <<~TEXT
              Middleware `#{middleware.inspect}` is NOT found in the stack.
            TEXT
          end

          before do
            stack_builder.clear
          end

          it "raises `ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Stateful::Exceptions::MissingMiddleware`" do
            expect { stack_builder.insert(middleware, other_middleware) }
              .to raise_error(ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Stateful::Exceptions::MissingMiddleware)
              .with_message(exception_message)
          end

          specify do
            expect { ignoring_exception(ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Stateful::Exceptions::MissingMiddleware) { stack_builder.insert(middleware, other_middleware) } }
              .to delegate_to(ConvenientService, :raise)
          end
        end

        context "when that middleware is found in stack" do
          before do
            stack_builder.use(middleware)
          end

          specify do
            expect { stack_builder.insert(middleware, other_middleware) }
              .to delegate_to(stack, :insert)
                .with_arguments(index, other_middleware)
                .and_return { stack_builder }
          end
        end
      end
    end

    describe "#insert_before" do
      context "when `index_or_middleware` is integer" do
        specify do
          expect { stack_builder.insert_before(index, other_middleware) }
            .to delegate_to(stack, :insert)
              .with_arguments(index, other_middleware)
              .and_return { stack_builder }
        end
      end

      context "when `index_or_middleware` is middleware" do
        context "when that middleware is NOT found in stack" do
          let(:exception_message) do
            <<~TEXT
              Middleware `#{middleware.inspect}` is NOT found in the stack.
            TEXT
          end

          before do
            stack_builder.clear
          end

          it "raises `ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Stateful::Exceptions::MissingMiddleware`" do
            expect { stack_builder.insert_before(middleware, other_middleware) }
              .to raise_error(ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Stateful::Exceptions::MissingMiddleware)
              .with_message(exception_message)
          end

          specify do
            expect { ignoring_exception(ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Stateful::Exceptions::MissingMiddleware) { stack_builder.insert_before(middleware, other_middleware) } }
              .to delegate_to(ConvenientService, :raise)
          end
        end

        context "when that middleware is found in stack" do
          before do
            stack_builder.use(middleware)
          end

          specify do
            expect { stack_builder.insert_before(middleware, other_middleware) }
              .to delegate_to(stack, :insert)
                .with_arguments(index, other_middleware)
                .and_return { stack_builder }
          end
        end
      end
    end

    describe "#insert_after" do
      context "when `index_or_middleware` is integer" do
        specify do
          expect { stack_builder.insert_after(index, other_middleware) }
            .to delegate_to(stack, :insert)
              .with_arguments(index + 1, other_middleware)
              .and_return { stack_builder }
        end
      end

      context "when `index_or_middleware` is middleware" do
        context "when that middleware is NOT found in stack" do
          let(:exception_message) do
            <<~TEXT
              Middleware `#{middleware.inspect}` is NOT found in the stack.
            TEXT
          end

          before do
            stack_builder.clear
          end

          it "raises `ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Stateful::Exceptions::MissingMiddleware`" do
            expect { stack_builder.insert_after(middleware, other_middleware) }
              .to raise_error(ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Stateful::Exceptions::MissingMiddleware)
              .with_message(exception_message)
          end

          specify do
            expect { ignoring_exception(ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Stateful::Exceptions::MissingMiddleware) { stack_builder.insert_after(middleware, other_middleware) } }
              .to delegate_to(ConvenientService, :raise)
          end
        end

        context "when that middleware is found in stack" do
          before do
            stack_builder.use(middleware)
          end

          specify do
            expect { stack_builder.insert_after(middleware, other_middleware) }
              .to delegate_to(stack, :insert)
                .with_arguments(index + 1, other_middleware)
                .and_return { stack_builder }
          end
        end
      end
    end

    describe "#insert_before_each" do
      before do
        stack_builder.use(middleware)
        stack_builder.use(middleware)
      end

      it "returns stack builder" do
        expect(stack_builder.insert_before_each(other_middleware)).to eq(stack_builder)
      end

      it "adds other middleware before each middleware" do
        stack_builder.insert_before_each(other_middleware)

        expect(stack_builder.to_a).to eq([other_middleware, middleware, other_middleware, middleware])
      end
    end

    describe "#insert_after_each" do
      before do
        stack_builder.use(middleware)
        stack_builder.use(middleware)
      end

      it "returns stack builder" do
        expect(stack_builder.insert_after_each(other_middleware)).to eq(stack_builder)
      end

      it "adds other middleware after each middleware" do
        stack_builder.insert_after_each(other_middleware)

        expect(stack_builder.to_a).to eq([middleware, other_middleware, middleware, other_middleware])
      end
    end

    describe "#replace" do
      context "when `index_or_middleware` is integer" do
        specify do
          expect { stack_builder.replace(index, other_middleware) }
            .to delegate_to(stack, :[]=)
              .with_arguments(index, other_middleware)
              .and_return { stack_builder }
        end
      end

      context "when `index_or_middleware` is middleware" do
        context "when that middleware is NOT found in stack" do
          let(:exception_message) do
            <<~TEXT
              Middleware `#{middleware.inspect}` is NOT found in the stack.
            TEXT
          end

          before do
            stack_builder.clear
          end

          it "raises `ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Stateful::Exceptions::MissingMiddleware`" do
            expect { stack_builder.replace(middleware, other_middleware) }
              .to raise_error(ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Stateful::Exceptions::MissingMiddleware)
              .with_message(exception_message)
          end

          specify do
            expect { ignoring_exception(ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Stateful::Exceptions::MissingMiddleware) { stack_builder.replace(middleware, other_middleware) } }
              .to delegate_to(ConvenientService, :raise)
          end
        end

        context "when that middleware is found in stack" do
          before do
            stack_builder.use(middleware)
          end

          specify do
            expect { stack_builder.replace(middleware, other_middleware) }
              .to delegate_to(stack, :[]=)
                .with_arguments(index, other_middleware)
                .and_return { stack_builder }
          end
        end
      end
    end

    describe "#delete" do
      context "when stack does NOT have middleware" do
        let(:exception_message) do
          <<~TEXT
            Middleware `#{middleware.inspect}` is NOT found in the stack.
          TEXT
        end

        before do
          stack_builder.clear
        end

        it "raises `ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Stateful::Exceptions::MissingMiddleware`" do
          expect { stack_builder.delete(middleware) }
            .to raise_error(ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Stateful::Exceptions::MissingMiddleware)
            .with_message(exception_message)
        end

        specify do
          expect { ignoring_exception(ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Stateful::Exceptions::MissingMiddleware) { stack_builder.delete(middleware) } }
            .to delegate_to(ConvenientService, :raise)
        end
      end

      context "when stack does has middleware" do
        before do
          stack_builder.use(middleware)
        end

        it "removes that middleware from stack" do
          stack_builder.delete(middleware)

          expect(stack_builder.empty?).to eq(true)
        end

        it "returns stack builder" do
          expect(stack_builder.delete(middleware)).to eq(stack_builder)
        end
      end
    end

    describe "#remove" do
      context "when stack does NOT have middleware" do
        before do
          stack_builder.clear
        end

        let(:exception_message) do
          <<~TEXT
            Middleware `#{middleware.inspect}` is NOT found in the stack.
          TEXT
        end

        it "raises `ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Stateful::Exceptions::MissingMiddleware`" do
          expect { stack_builder.remove(middleware) }
            .to raise_error(ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Stateful::Exceptions::MissingMiddleware)
            .with_message(exception_message)
        end

        specify do
          expect { ignoring_exception(ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Stateful::Exceptions::MissingMiddleware) { stack_builder.remove(middleware) } }
            .to delegate_to(ConvenientService, :raise)
        end
      end

      context "when stack does has middleware" do
        before do
          stack_builder.use(middleware)
        end

        it "removes that middleware from stack" do
          stack_builder.remove(middleware)

          expect(stack_builder.empty?).to eq(true)
        end

        it "returns stack builder" do
          expect(stack_builder.remove(middleware)).to eq(stack_builder)
        end
      end
    end

    describe "#to_a" do
      before do
        stack_builder.use(middleware)
        stack_builder.use(other_middleware)
      end

      it "returns stack" do
        expect(stack_builder.to_a).to eq(stack)
      end
    end

    describe "#dup" do
      ##
      # NOTE: Unfreezes string since it is NOT possible to set spy on frozen objects.
      #
      let(:name) { +"Stack" }

      before do
        ##
        # NOTE: Create stack, before setting spies on `stack_class.new`, `name.dup`.
        #
        stack_builder
      end

      specify do
        expect { stack_builder.dup }
          .to delegate_to(described_class, :new)
          .with_arguments(name: name, stack: stack)
          .and_return_its_value
      end

      specify { expect { stack_builder.dup }.to delegate_to(name, :dup) }

      specify { expect { stack_builder.dup }.to delegate_to(stack, :dup) }
    end

    example_group "comparison" do
      describe "#==" do
        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `false`" do
            expect(stack_builder == other).to be_nil
          end
        end

        context "when `other` has different `name`" do
          let(:other) { described_class.new(name: "OtherStack", stack: stack) }

          it "returns `false`" do
            expect(stack_builder == other).to eq(false)
          end
        end

        context "when `other` has different `plain_stack`" do
          let(:other) { described_class.new(name: name, stack: [middleware]) }

          it "returns `false`" do
            expect(stack_builder == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(name: name, stack: stack) }

          it "returns `true`" do
            expect(stack_builder == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
