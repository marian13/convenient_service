# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::MiddlewareCreators::Base, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:middleware_creator_class) { described_class }
  let(:middleware_creator) { middleware_creator_class.new(middleware: middleware) }

  let(:middleware) { Class.new(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain) }

  let(:args) { :foo }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Delegate) }
  end

  example_group "class methods" do
    describe ".new" do
      context "when `middleware` is NOT passed" do
        let(:middleware_creator) { described_class.new }

        it "raises `KeyError`" do
          expect { middleware_creator }.to raise_error(KeyError).with_message("key not found: :middleware")
        end
      end
    end
  end

  example_group "instance methods" do
    example_group "attributes" do
      include ConvenientService::RSpec::PrimitiveMatchers::HaveAttrReader

      subject { middleware_creator }

      it { is_expected.to have_attr_reader(:middleware) }
    end

    describe "#to_observable_middleware" do
      specify do
        expect { middleware_creator.to_observable_middleware }
          .to delegate_to(middleware, :to_observable_middleware)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#with" do
      specify do
        expect { middleware_creator.with(*args, **kwargs, &block) }
          .to delegate_to(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::MiddlewareCreators::With, :new)
          .with_arguments(middleware: middleware_creator, middleware_arguments: ConvenientService::Support::Arguments.new(*args, **kwargs, &block))
          .and_return_its_value
      end
    end

    describe "#observable" do
      specify do
        expect { middleware_creator.observable }
          .to delegate_to(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::MiddlewareCreators::Observable, :new)
          .with_arguments(middleware: middleware_creator)
          .and_return_its_value
      end
    end

    describe "#new" do
      let(:stack) { ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Stack.new }
      let(:env) { {foo: :bar} }

      it "returns instance of decorated middleware" do
        expect(middleware_creator.new(stack, env: env)).to be_instance_of(middleware_creator.decorated_middleware)
      end

      specify do
        expect { middleware_creator.new(stack, env: env) }
          .to delegate_to(middleware_creator.decorated_middleware, :new)
          .with_arguments(stack, env: env)
          .and_return_its_value
      end

      context "when `env` is NOT passed" do
        it "defaults to empty hash" do
          expect(middleware_creator.new(stack).instance_variable_get(:@__env__)).to eq({})
        end
      end

      context "when `middleware_arguments` are NOT passed" do
        it "defaults to null arguments" do
          expect(middleware_creator.new(stack).middleware_arguments).to eq(ConvenientService::Support::Arguments.null_arguments)
        end
      end

      context "when middleware creator has extra kwargs" do
        let(:middleware_creator_class) do
          Class.new(described_class) do
            def extra_kwargs
              {middleware_arguments: ConvenientService::Support::Arguments.new}
            end
          end
        end

        it "merges them with kwargs" do
          expect { middleware_creator.new(stack, env: env) }
            .to delegate_to(middleware_creator.decorated_middleware, :new)
            .with_arguments(stack, env: env, middleware_arguments: ConvenientService::Support::Arguments.new)
            .and_return_its_value
        end
      end

      context "when middleware has extra kwargs" do
        let(:middleware) do
          Class.new(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain) do
            def self.extra_kwargs
              {foo: :bar}
            end
          end
        end

        it "merges them with kwargs" do
          expect { middleware_creator.new(stack, env: env) }
            .to delegate_to(middleware_creator.decorated_middleware, :new)
            .with_arguments(stack, env: env, foo: :bar)
            .and_return_its_value
        end
      end

      context "when both middleware creator and middleware have extra kwargs" do
        let(:middleware_creator_class) do
          Class.new(described_class) do
            def extra_kwargs
              {foo: :bar}
            end
          end
        end

        let(:middleware) do
          Class.new(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain) do
            def self.extra_kwargs
              {foo: :baz}
            end
          end
        end

        it "merges middleware extra kwargs with higher precedence than middleware creator extra kwargs" do
          expect { middleware_creator.new(stack, env: env) }
            .to delegate_to(middleware_creator.decorated_middleware, :new)
            .with_arguments(stack, env: env, foo: :baz)
            .and_return_its_value
        end

        it "merges kwargs with higher precedence than middleware extra kwargs" do
          expect { middleware_creator.new(stack, env: env, foo: :qux) }
            .to delegate_to(middleware_creator.decorated_middleware, :new)
            .with_arguments(stack, env: env, foo: :qux)
            .and_return_its_value
        end
      end
    end

    describe "#decorated_middleware" do
      it "returns middleware" do
        expect(middleware_creator.decorated_middleware).to eq(middleware)
      end
    end

    describe "#extra_kwargs" do
      it "returns empty hash" do
        expect(middleware_creator.extra_kwargs).to eq({})
      end
    end

    example_group "comparison" do
      describe "#==" do
        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(middleware_creator == other).to be_nil
          end
        end

        context "when `other` has different `middleware`" do
          let(:other) { described_class.new(middleware: Class.new(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain)) }

          it "returns `false`" do
            expect(middleware_creator == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(middleware: middleware) }

          it "returns `true`" do
            expect(middleware_creator == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
