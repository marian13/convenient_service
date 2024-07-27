# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Rack, type: :standard do
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
    example_group "attributes" do
      include ConvenientService::RSpec::PrimitiveMatchers::HaveAttrReader

      subject { stack_builder }

      it { is_expected.to have_attr_reader(:name) }
      it { is_expected.to have_attr_reader(:stack) }
    end

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

    describe "#unshift" do
      let(:middleware) { proc { :foo } }

      specify do
        expect { stack_builder.unshift(middleware) }
          .to delegate_to(stack, :unshift)
            .with_arguments(middleware)
            .and_return { stack_builder }
      end
    end

    describe "#prepend" do
      let(:middleware) { proc { :foo } }

      specify do
        expect { stack_builder.prepend(middleware) }
          .to delegate_to(stack, :unshift)
            .with_arguments(middleware)
            .and_return { stack_builder }
      end
    end

    describe "#delete" do
      let(:middleware) { proc { :foo } }

      context "when stack does NOT have middleware" do
        let(:exception_message) do
          <<~TEXT
            Middleware `#{middleware.inspect}` is NOT found in the stack.
          TEXT
        end

        before do
          stack_builder.clear
        end

        it "raises `ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Rack::Exceptions::MissingMiddleware`" do
          expect { stack_builder.delete(middleware) }
            .to raise_error(ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Rack::Exceptions::MissingMiddleware)
            .with_message(exception_message)
        end

        specify do
          expect { ignoring_exception(ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Rack::Exceptions::MissingMiddleware) { stack_builder.delete(middleware) } }
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
      let(:middleware) { proc { :foo } }

      context "when stack does NOT have middleware" do
        before do
          stack_builder.clear
        end

        let(:exception_message) do
          <<~TEXT
            Middleware `#{middleware.inspect}` is NOT found in the stack.
          TEXT
        end

        it "raises `ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Rack::Exceptions::MissingMiddleware`" do
          expect { stack_builder.remove(middleware) }
            .to raise_error(ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Rack::Exceptions::MissingMiddleware)
            .with_message(exception_message)
        end

        specify do
          expect { ignoring_exception(ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Rack::Exceptions::MissingMiddleware) { stack_builder.remove(middleware) } }
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
      it "returns stack" do
        expect(stack_builder.to_a).to eq(stack)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
