# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middleware do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:middleware_result) { middleware_instance.call(env) }
  let(:middleware_instance) { middleware_class.new(stack) }

  let(:middleware_class) do
    Class.new(described_class) do
      def next(...)
        chain.next(...)
      end
    end
  end

  let(:stack) { ConvenientService::Support::Middleware::StackBuilder.new }
  let(:env) { {entity: double, method: :result, args: args, kwargs: kwargs, block: block} }

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  example_group "abstract methods" do
    include ConvenientService::RSpec::Matchers::HaveAbstractMethod

    subject { described_class.new(stack) }

    it { is_expected.to have_abstract_method(:next) }
  end

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
      it "returns instance of `ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::MiddlewareCreator`" do
        expect(middleware_class.with(*args, **kwargs, &block)).to be_instance_of(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::MiddlewareCreator)
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

  example_group "instance methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo
    include ConvenientService::RSpec::Matchers::CacheItsValue

    describe "#call" do
      it "sets middleware @env instance variable to `env`" do
        expect { middleware_result }.to change { middleware_instance.instance_variable_get(:@__env__) }.from({}).to(env)
      end

      it "sets middleware chain @env instance variable to `env`" do
        expect { middleware_result }.to change { middleware_instance.chain.instance_variable_get(:@env) }.from({}).to(env)
      end

      specify do
        expect { middleware_result }
          .to delegate_to(middleware_instance, :next)
          .with_arguments(*env[:args], **env[:kwargs], &env[:block])
          .and_return_its_value
      end
    end

    describe "#entity" do
      context "when middleware is NOT called" do
        it "returns `nil`" do
          expect(middleware_instance.entity).to eq(nil)
        end
      end

      context "when middleware is called" do
        it "returns `env[:entity]" do
          middleware_result

          expect(middleware_instance.entity).to eq(env[:entity])
        end
      end
    end

    describe "#method" do
      context "when middleware is NOT called" do
        it "returns `nil`" do
          expect(middleware_instance.method).to eq(nil)
        end
      end

      context "when middleware is called" do
        it "returns `env[:method]" do
          middleware_result

          expect(middleware_instance.method).to eq(env[:method])
        end
      end
    end

    describe "#chain" do
      it "returns chain" do
        expect(middleware_instance.chain).to eq(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Chain.new(stack: stack))
      end

      specify { expect { middleware_instance.chain }.to cache_its_value }
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
