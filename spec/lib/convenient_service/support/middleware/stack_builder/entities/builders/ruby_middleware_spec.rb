# frozen_string_literal: true

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
    describe "#has?" do
      let(:middleware) { proc { :foo } }

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

    describe "#unshift" do
      let(:middleware) { proc { :foo } }

      specify do
        expect { stack_builder.unshift(middleware, *args, &block) }
          .to delegate_to(stack, :unshift)
            .with_arguments([middleware, args, block])
            .and_return { stack_builder }
      end
    end

    describe "#prepend" do
      let(:middleware) { proc { :foo } }

      specify do
        expect { stack_builder.prepend(middleware, *args, &block) }
          .to delegate_to(stack, :unshift)
            .with_arguments([middleware, args, block])
            .and_return { stack_builder }
      end
    end

    describe "#delete" do
      let(:middleware) { proc { :foo } }

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
      let(:middleware) { proc { :foo } }

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
      it "returns stack" do
        expect(stack_builder.to_a).to eq(stack)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
