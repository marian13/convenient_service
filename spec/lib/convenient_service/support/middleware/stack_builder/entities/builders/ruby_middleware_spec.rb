# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::RubyMiddleware, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:stack_builder) { described_class.new(name: name, stack: stack) }

  let(:stack) { [] }
  let(:name) { "Stack" }

  let(:args) { [:foo] }
  let(:block) { proc { :foo } }

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Dependencies::Extractions::RubyMiddleware::Middleware::Builder) }
  end

  example_group "class methods" do
    describe ".new" do
      context "when `name` is NOT passed" do
        it "defaults `\"Stack\"`" do
          expect(stack_builder.name).to eq("Stack")
        end
      end

      context "when `stack` is NOT passed" do
        ##
        # NOTE: Indirect test since `stack` is protected.
        #
        it "defaults to empty array" do
          expect(stack_builder.empty?).to eq(true)
        end
      end
    end
  end

  example_group "instance methods" do
    let(:middleware) { proc { :foo } }
    let(:other_middleware) { proc { :bar } }

    describe "#has?" do
      context "when stack does NOT have middleware" do
        before do
          stack_builder.clear
        end

        it "returns `false`" do
          expect(stack_builder.has?(middleware)).to eq(false)
        end
      end

      context "when stack has middleware" do
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
        stub_const("ConvenientService::Support::Middleware::StackBuilder::Constants::Backends::DEFAULT", ConvenientService::Support::Middleware::StackBuilder::Constants::Backends::RUBY_MIDDLEWARE)
      end

      it "runs middleware stack" do
        expect(service.result.success?).to eq(true)
      end
    end

    describe "#unshift" do
      specify do
        expect { stack_builder.unshift(middleware, *args, &block) }
          .to delegate_to(stack, :unshift)
            .with_arguments([middleware, args, block])
            .and_return { stack_builder }
      end
    end

    describe "#prepend" do
      specify do
        expect { stack_builder.prepend(middleware, *args, &block) }
          .to delegate_to(stack, :unshift)
            .with_arguments([middleware, args, block])
            .and_return { stack_builder }
      end
    end

    describe "#use" do
      specify do
        expect { stack_builder.use(middleware, *args, &block) }
          .to delegate_to(stack, :<<)
            .with_arguments([middleware, args, block])
            .and_return { stack_builder }
      end
    end

    describe "#append" do
      specify do
        expect { stack_builder.append(middleware, *args, &block) }
          .to delegate_to(stack, :<<)
            .with_arguments([middleware, args, block])
            .and_return { stack_builder }
      end
    end

    describe "#delete" do
      context "when stack does NOT have middleware" do
        let(:exception_message) { "no implicit conversion from nil to integer" }

        before do
          stack_builder.clear
        end

        it "raises `TypeError`" do
          expect { stack_builder.delete(middleware) }
            .to raise_error(TypeError)
            .with_message(exception_message)
        end

        ##
        # NOTE: `TypeError` exception is raised by `Array#index` from `ruby_middleware` gem. That is why is NOT processed by `ConvenientService.raise`.
        #
        # specify do
        #   expect { ignoring_exception(TypeError) { stack_builder.delete(middleware) } }
        #     .to delegate_to(ConvenientService, :raise)
        # end
      end

      context "when stack has middleware" do
        before do
          stack_builder.use(middleware)
        end

        it "removes that middleware from stack" do
          stack_builder.delete(middleware)

          expect(stack_builder.empty?).to eq(true)
        end

        ##
        # NOTE: Currently `ruby_middleware` is not fully compatible with `rack`.
        # TODO: Make `ruby_middleware` and `rack` fully compatible?
        #
        it "returns deleted middleware" do
          expect(stack_builder.delete(middleware)).to eq([middleware, [], nil])
        end
      end
    end

    describe "#remove" do
      context "when stack does NOT have middleware" do
        before do
          stack_builder.clear
        end

        let(:exception_message) { "no implicit conversion from nil to integer" }

        it "raises `TypeError`" do
          expect { stack_builder.delete(middleware) }
            .to raise_error(TypeError)
            .with_message(exception_message)
        end

        ##
        # NOTE: `TypeError` exception is raised by `Array#index` from `ruby_middleware` gem. That is why is NOT processed by `ConvenientService.raise`.
        #
        # specify do
        #   expect { ignoring_exception(TypeError) { stack_builder.delete(middleware) } }
        #     .to delegate_to(ConvenientService, :raise)
        # end
      end

      context "when stack does has middleware" do
        before do
          stack_builder.use(middleware)
        end

        it "removes that middleware from stack" do
          stack_builder.remove(middleware)

          expect(stack_builder.empty?).to eq(true)
        end

        ##
        # NOTE: Currently `ruby_middleware` is not fully compatible with `rack`.
        # TODO: Make `ruby_middleware` and `rack` fully compatible?
        #
        it "returns removed middleware" do
          expect(stack_builder.remove(middleware)).to eq([middleware, [], nil])
        end
      end
    end

    describe "#to_a" do
      before do
        stack_builder.use(middleware)
        stack_builder.use(other_middleware)
      end

      it "returns middlewares without args and block" do
        expect(stack_builder.to_a).to eq([middleware, other_middleware])
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
          .with_arguments(name: name, stack: stack, runner_class: ConvenientService::Dependencies::Extractions::RubyMiddleware::Middleware::Runner)
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
          let(:other) { described_class.new(name: name, stack: [[middleware, [], nil]]) }

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
