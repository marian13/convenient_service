# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Concerns::Entities::Middleware do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:middleware_result) { middleware_instance.call(env) }
  let(:middleware_instance) { middleware_class.new(stack) }
  let(:middleware_class) { described_class.cast(mod) }

  let(:mod) { Module.new }

  let(:stack) { ConvenientService::Support::Middleware::StackBuilder.new }
  let(:env) { {entity: entity, method: :result, args: args, kwargs: kwargs, block: block} }

  let(:entity) { Class.new }
  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::Matchers::ExtendModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Castable) }
    it { is_expected.to extend_module(ConvenientService::Support::AbstractMethod) }
  end

  example_group "class abstract methods" do
    include ConvenientService::RSpec::Matchers::HaveAbstractMethod

    subject { described_class }

    it { is_expected.to have_abstract_method(:concern) }
  end

  example_group "instance_methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    describe "#call" do
      it "includes `mod` to `env[:entity]`" do
        expect { middleware_result }.to change { entity.include?(mod) }.from(false).to(true)
      end

      specify do
        expect { middleware_result }
          .to delegate_to(stack, :call)
          .with_arguments(env)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
