# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base::Concern::InstanceMethods do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:middleware_class) { Class.new(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base) }
  let(:middleware) { middleware_class.new(stack) }

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

    describe "#middleware_arguments" do
      let(:middleware) { middleware_class.new(stack, middleware_arguments: middleware_arguments) }
      let(:middleware_arguments) { ConvenientService::Support::Arguments.new(*args, **kwargs, &block) }

      it "returns middleware_arguments" do
        expect(middleware.middleware_arguments).to eq(middleware_arguments)
      end
    end

    example_group "comparison" do
      describe "#==" do
        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(middleware == other).to be_nil
          end
        end

        context "when `other` has different `stack`" do
          let(:other) { middleware_class.new(ConvenientService::Support::Middleware::StackBuilder.new.use(proc { :foo })) }

          it "returns `false`" do
            expect(middleware == other).to eq(false)
          end
        end

        context "when `other` has different `env`" do
          let(:other) { middleware_class.new(stack, env: {foo: :bar}) }

          it "returns `false`" do
            expect(middleware == other).to eq(false)
          end
        end

        context "when `other` has different `middleware_arguments`" do
          let(:other) { middleware_class.new(stack, middleware_arguments: ConvenientService::Support::Arguments.new(:foo)) }

          it "returns `false`" do
            expect(middleware == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { middleware_class.new(stack) }

          it "returns `true`" do
            expect(middleware == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
