# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::RubyMiddleware, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:stack_builder) { described_class.new(stack: stack) }

  let(:stack) { [] }

  let(:args) { [:foo] }
  let(:block) { proc { :foo } }

  example_group "instance methods" do
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

    describe "#to_a" do
      it "returns stack" do
        expect(stack_builder.to_a).to eq(stack)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
