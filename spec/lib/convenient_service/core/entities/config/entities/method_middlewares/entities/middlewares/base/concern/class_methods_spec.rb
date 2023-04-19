# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base::ClassMethods do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:middleware_instance) { middleware_class.new(stack) }
  let(:middleware_class) { Class.new(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base) }

  let(:stack) { ConvenientService::Support::Middleware::StackBuilder.new }
  let(:env) { {entity: double, method: :result, args: args, kwargs: kwargs, block: block} }

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  example_group "class methods" do
    describe ".new" do
      context "when `env` is NOT passed" do
        let(:middleware_instance) { middleware_class.new(stack) }

        it "defaults to empty hash" do
          expect(middleware_instance.instance_variable_get(:@__env__)).to eq({})
        end
      end

      context "when `arguments` is NOT passed" do
        let(:middleware_instance) { middleware_class.new(stack) }

        it "defaults to `ConvenientService::Support::Arguments.null_arguments`" do
          expect(middleware_instance.instance_variable_get(:@__arguments__)).to eq(ConvenientService::Support::Arguments.null_arguments)
        end
      end
    end

    describe ".with" do
      it "returns instance of `ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base::Entities::MiddlewareCreator`" do
        expect(middleware_class.with(*args, **kwargs, &block)).to be_instance_of(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base::Entities::MiddlewareCreator)
      end

      example_group "`middleware_creator`" do
        it "has middleware set to `middleware`" do
          expect(middleware_class.with(*args, **kwargs, &block).middleware).to eq(middleware_class)
        end

        it "has arguments set to `arguments`" do
          expect(middleware_class.with(*args, **kwargs, &block).arguments).to eq(ConvenientService::Support::Arguments.new(*args, **kwargs, &block))
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
