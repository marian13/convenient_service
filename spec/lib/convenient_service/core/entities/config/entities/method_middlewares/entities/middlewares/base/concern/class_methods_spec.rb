# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base::Concern::ClassMethods, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:middleware_class) { Class.new(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base) }
  let(:middleware) { middleware_class.new(stack) }

  let(:stack) { ConvenientService::Support::Middleware::StackBuilder.new }
  let(:env) { {entity: double, method: :result, args: args, kwargs: kwargs, block: block} }

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  example_group "class methods" do
    describe ".new" do
      context "when `env` is NOT passed" do
        let(:middleware) { middleware_class.new(stack) }

        it "defaults to empty hash" do
          expect(middleware.instance_variable_get(:@__env__)).to eq({})
        end
      end

      context "when `arguments` is NOT passed" do
        let(:middleware) { middleware_class.new(stack) }

        it "defaults to `ConvenientService::Support::Arguments.null_arguments`" do
          expect(middleware.middleware_arguments).to eq(ConvenientService::Support::Arguments.null_arguments)
        end
      end
    end

    describe ".from" do
      let(:option) { ConvenientService::Config::Entities::Option.new(name: :some_option, enabled: true, **data) }
      let(:data) { {foo: :bar, baz: :qux, quux: :quuz} }
      let(:data_keys) { [:foo, :baz] }

      context "when `option` is `nil`" do
        let(:option) { nil }

        it "returns original middleware class" do
          expect(middleware_class.from(option, *data_keys)).to eq(middleware_class)
        end
      end

      context "when `data_keys` are empty" do
        let(:data_keys) { [] }

        it "returns original middleware class" do
          expect(middleware_class.from(option, *data_keys)).to eq(middleware_class)
        end
      end

      context "when `option` data is empty" do
        let(:data) { {} }

        it "returns original middleware class" do
          expect(middleware_class.from(option, *data_keys)).to eq(middleware_class)
        end
      end

      context "when `data_keys` are subset of `option` data" do
        let(:data_keys) { [:foo, :quux] }

        specify do
          expect { middleware_class.from(option, *data_keys) }
            .to delegate_to(middleware_class, :with)
            .with_arguments(**{foo: :bar, quux: :quuz})
            .and_return_its_value
        end
      end

      context "when `data_keys` are superset of `option` data" do
        let(:data_keys) { [:foo, :quux, :cargo] }

        specify do
          expect { middleware_class.from(option, *data_keys) }
            .to delegate_to(middleware_class, :with)
            .with_arguments(**{foo: :bar, quux: :quuz})
            .and_return_its_value
        end
      end
    end

    describe ".with" do
      specify do
        expect { middleware_class.with(*args, **kwargs, &block) }
          .to delegate_to(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::MiddlewareCreators::With, :new)
          .with_arguments(middleware: middleware_class, middleware_arguments: ConvenientService::Support::Arguments.new(*args, **kwargs, &block))
          .and_return_its_value
      end
    end

    describe ".observable" do
      specify do
        expect { middleware_class.observable }
          .to delegate_to(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::MiddlewareCreators::Observable, :new)
          .with_arguments(middleware: middleware_class)
          .and_return_its_value
      end
    end

    describe ".extra_kwargs" do
      it "returns empty hash" do
        expect(middleware_class.extra_kwargs).to eq({})
      end
    end

    describe ".intended_methods" do
      it "returns empty array" do
        expect(middleware_class.intended_methods).to eq([])
      end
    end

    describe ".to_observable_middleware" do
      specify do
        expect { middleware_class.to_observable_middleware }
          .to delegate_to(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base::Commands::CreateObservableMiddleware, :call)
          .with_arguments(middleware: middleware_class)
          .and_return_its_value
      end
    end

    describe ".intended_for" do
      let(:method) { :result }
      let(:entity) { :service }
      let(:scope) { :class }

      it "adds intended method to intended methods" do
        middleware_class.intended_for(method, entity: entity, scope: scope)

        expect(middleware_class.intended_methods).to eq([ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base::Structs::IntendedMethod.new(method, scope, entity)])
      end

      it "returns added intended method" do
        expect(middleware_class.intended_for(method, entity: entity, scope: scope)).to eq(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base::Structs::IntendedMethod.new(method, scope, entity))
      end

      specify do
        expect { middleware_class.intended_for(method, entity: entity, scope: scope) }
          .to delegate_to(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base::Structs::IntendedMethod, :new)
          .with_arguments(method, scope, entity)
      end

      context "when `scope` is NOT passed" do
        it "defaults to `:instance`" do
          expect(middleware_class.intended_for(method, entity: entity)).to eq(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base::Structs::IntendedMethod.new(method, :instance, entity))
        end
      end
    end

    describe ".any_method" do
      it "returns `ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base::Constants::ANY_METHOD`" do
        expect(middleware_class.any_method).to eq(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base::Constants::ANY_METHOD)
      end
    end

    describe ".any_scope" do
      it "returns `ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base::Constants::ANY_SCOPE`" do
        expect(middleware_class.any_scope).to eq(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base::Constants::ANY_SCOPE)
      end
    end

    describe ".any_entity" do
      it "returns `ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base::Constants::ANY_ENTITY`" do
        expect(middleware_class.any_entity).to eq(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base::Constants::ANY_ENTITY)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
