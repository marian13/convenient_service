# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Helpers::Classes::WrapMethod::Entities::WrappedMethod, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::CacheItsValue

  subject(:method) { described_class.new(entity: entity, method: method_name, observe_middleware: middleware) }

  let(:service_class) do
    Class.new.tap do |klass|
      klass.class_exec(method_name, middleware) do |method_name, middleware|
        include ConvenientService::Standard::Config

        middlewares method_name do
          observe middleware
        end

        def result
          success(data: {from: :original_result})
        end
      end
    end
  end

  let(:service_instance) { service_class.new }

  let(:entity) { service_instance }
  let(:method_name) { :result }
  let(:middleware) { ConvenientService::Plugins::Common::CachesReturnValue::Middleware }

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  example_group "instance methods" do
    ##
    # TODO: Specs.
    ##

    describe "#chain_called?" do
      context "when chain is NOT called" do
        it "returns `false`" do
          expect(method.chain_called?).to eq(false)
        end
      end

      context "when chain is called" do
        before do
          method.call
        end

        it "returns `true`" do
          expect(method.chain_called?).to eq(true)
        end
      end
    end

    describe "#chain_value" do
      context "when chain is NOT called" do
        let(:exception_message) do
          <<~TEXT
            Chain attribute `value` is accessed before the chain is called.
          TEXT
        end

        it "raises `ConvenientService::RSpec::Helpers::Classes::WrapMethod::Exceptions::ChainAttributePreliminaryAccess`" do
          expect { method.chain_value }
            .to raise_error(ConvenientService::RSpec::Helpers::Classes::WrapMethod::Exceptions::ChainAttributePreliminaryAccess)
            .with_message(exception_message)
        end

        specify do
          expect { ignoring_exception(ConvenientService::RSpec::Helpers::Classes::WrapMethod::Exceptions::ChainAttributePreliminaryAccess) { method.chain_value } }
            .to delegate_to(ConvenientService, :raise)
        end
      end

      context "when chain is called" do
        before do
          method.call
        end

        it "returns chain value" do
          expect(method.chain_value).to be_success.with_data(from: :original_result)
        end

        specify do
          expect { method.chain_value }.to cache_its_value
        end
      end
    end

    describe "#chain_args" do
      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(method_name, middleware) do |method_name, middleware|
            include ConvenientService::Standard::Config

            middlewares method_name do
              observe middleware
            end

            def result(*args)
              success(data: {from: :original_result})
            end
          end
        end
      end

      context "when chain is NOT called" do
        let(:exception_message) do
          <<~TEXT
            Chain attribute `args` is accessed before the chain is called.
          TEXT
        end

        it "raises `ConvenientService::RSpec::Helpers::Classes::WrapMethod::Exceptions::ChainAttributePreliminaryAccess`" do
          expect { method.chain_args }
            .to raise_error(ConvenientService::RSpec::Helpers::Classes::WrapMethod::Exceptions::ChainAttributePreliminaryAccess)
            .with_message(exception_message)
        end

        specify do
          expect { ignoring_exception(ConvenientService::RSpec::Helpers::Classes::WrapMethod::Exceptions::ChainAttributePreliminaryAccess) { method.chain_args } }
            .to delegate_to(ConvenientService, :raise)
        end
      end

      context "when chain is called" do
        before do
          method.call(*args)
        end

        it "returns chain args" do
          expect(method.chain_args).to eq(args)
        end

        specify do
          expect { method.chain_args }.to cache_its_value
        end
      end
    end

    describe "#chain_kwargs" do
      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(method_name, middleware) do |method_name, middleware|
            include ConvenientService::Standard::Config

            middlewares method_name do
              observe middleware
            end

            def result(*kwargs)
              success(data: {from: :original_result})
            end
          end
        end
      end

      context "when chain is NOT called" do
        let(:exception_message) do
          <<~TEXT
            Chain attribute `kwargs` is accessed before the chain is called.
          TEXT
        end

        it "raises `ConvenientService::RSpec::Helpers::Classes::WrapMethod::Exceptions::ChainAttributePreliminaryAccess`" do
          expect { method.chain_kwargs }
            .to raise_error(ConvenientService::RSpec::Helpers::Classes::WrapMethod::Exceptions::ChainAttributePreliminaryAccess)
            .with_message(exception_message)
        end

        specify do
          expect { ignoring_exception(ConvenientService::RSpec::Helpers::Classes::WrapMethod::Exceptions::ChainAttributePreliminaryAccess) { method.chain_kwargs } }
            .to delegate_to(ConvenientService, :raise)
        end
      end

      context "when chain is called" do
        before do
          method.call(**kwargs)
        end

        it "returns chain kwargs" do
          expect(method.chain_kwargs).to eq(kwargs)
        end

        specify do
          expect { method.chain_block }.to cache_its_value
        end
      end
    end

    describe "#chain_block" do
      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(method_name, middleware) do |method_name, middleware|
            include ConvenientService::Standard::Config

            middlewares method_name do
              observe middleware
            end

            def result(&block)
              success(data: {from: :original_result})
            end
          end
        end
      end

      context "when chain is NOT called" do
        let(:exception_message) do
          <<~TEXT
            Chain attribute `block` is accessed before the chain is called.
          TEXT
        end

        it "raises `ConvenientService::RSpec::Helpers::Classes::WrapMethod::Exceptions::ChainAttributePreliminaryAccess`" do
          expect { method.chain_block }
            .to raise_error(ConvenientService::RSpec::Helpers::Classes::WrapMethod::Exceptions::ChainAttributePreliminaryAccess)
            .with_message(exception_message)
        end

        specify do
          expect { ignoring_exception(ConvenientService::RSpec::Helpers::Classes::WrapMethod::Exceptions::ChainAttributePreliminaryAccess) { method.chain_block } }
            .to delegate_to(ConvenientService, :raise)
        end
      end

      context "when chain is called" do
        before do
          method.call(&block)
        end

        it "returns chain block" do
          expect(method.chain_block).to eq(block)
        end

        specify do
          expect { method.chain_block }.to cache_its_value
        end
      end
    end

    describe "#chain_exception" do
      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(method_name, middleware) do |method_name, middleware|
            include ConvenientService::Standard::Config

            middlewares method_name do
              observe middleware
            end

            def result(&block)
              raise StandardError, "exception message"
            end
          end
        end
      end

      let(:exception) do
        service_instance.result
      rescue => error
        error
      end

      context "when chain is NOT called" do
        let(:exception_message) do
          <<~TEXT
            Chain attribute `exception` is accessed before the chain is called.
          TEXT
        end

        it "raises `ConvenientService::RSpec::Helpers::Classes::WrapMethod::Exceptions::ChainAttributePreliminaryAccess`" do
          expect { method.chain_exception }
            .to raise_error(ConvenientService::RSpec::Helpers::Classes::WrapMethod::Exceptions::ChainAttributePreliminaryAccess)
            .with_message(exception_message)
        end

        specify do
          expect { ignoring_exception(ConvenientService::RSpec::Helpers::Classes::WrapMethod::Exceptions::ChainAttributePreliminaryAccess) { method.chain_exception } }
            .to delegate_to(ConvenientService, :raise)
        end
      end

      context "when chain is called" do
        before do
          ignoring_exception(exception.class) { method.call }
        end

        it "returns chain exception" do
          expect([method.chain_exception.class, method.chain_exception.message]).to eq([exception.class, exception.message])
        end

        specify do
          expect { method.chain_exception }.to cache_its_value
        end
      end
    end

    example_group "comparison" do
      describe "#==" do
        context "when `other` have different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(method == other).to be_nil
          end
        end

        context "when `other` have different `entity`" do
          let(:other) { described_class.new(entity: service_class.new, method: method_name, observe_middleware: middleware) }

          it "returns `false`" do
            expect(method == other).to eq(false)
          end
        end

        context "when `other` have different `method`" do
          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(middleware) do |middleware|
                include ConvenientService::Standard::Config

                middlewares :result do
                  observe middleware
                end

                middlewares :negated_result do
                  observe middleware
                end

                def result
                  success(data: {from: :original_result})
                end
              end
            end
          end

          let(:other) { described_class.new(entity: service_instance, method: :negated_result, observe_middleware: middleware) }

          it "returns `false`" do
            expect(method == other).to eq(false)
          end
        end

        context "when `other` have different `observe_middleware`" do
          let(:other_middleware) { ConvenientService::Plugins::Common::CanHaveCallbacks::Middleware }

          let(:other) { described_class.new(entity: service_instance, method: method_name, observe_middleware: other_middleware) }

          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(middleware, other_middleware) do |middleware, other_middleware|
                include ConvenientService::Standard::Config

                middlewares :result do
                  observe middleware

                  observe other_middleware
                end

                def result
                  success(data: {from: :original_result})
                end
              end
            end
          end

          it "returns `false`" do
            expect(method == other).to eq(false)
          end
        end

        context "when `other` have different chain" do
          let(:other) { described_class.new(entity: entity, method: method_name, observe_middleware: middleware) }

          before do
            method.call
          end

          it "returns `false`" do
            expect(method == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(entity: entity, method: method_name, observe_middleware: middleware) }

          it "returns `true`" do
            expect(method == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
