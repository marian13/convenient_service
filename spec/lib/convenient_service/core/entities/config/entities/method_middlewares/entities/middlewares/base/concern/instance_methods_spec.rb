# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base::Concern::InstanceMethods do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:middleware_instance) { middleware_class.new(stack) }
  let(:middleware_class) { Class.new(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base) }

  let(:stack) { ConvenientService::Support::Middleware::StackBuilder.new }
  let(:env) { {entity: double, method: :result, args: args, kwargs: kwargs, block: block} }

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  example_group "instance methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo
    include ConvenientService::RSpec::Matchers::CacheItsValue

    example_group "abstract methods" do
      include ConvenientService::RSpec::Matchers::HaveAbstractMethod

      subject { ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base.new(stack) }

      it { is_expected.to have_abstract_method(:call) }
    end

    describe "#arguments" do
      let(:middleware_instance) { middleware_class.new(stack, arguments: arguments) }
      let(:arguments) { ConvenientService::Support::Arguments.new(*args, **kwargs, &block) }

      it "returns arguments" do
        expect(middleware_instance.arguments).to eq(arguments)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
