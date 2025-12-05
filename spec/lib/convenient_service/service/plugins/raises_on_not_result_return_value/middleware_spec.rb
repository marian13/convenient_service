# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Middleware, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:middleware) { described_class }

  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { middleware }

    it { is_expected.to be_descendant_of(ConvenientService::MethodChainMiddleware) }
  end

  example_group "class methods" do
    describe ".intended_methods" do
      let(:spec) do
        Class.new(ConvenientService::MethodChainMiddleware) do
          intended_for any_method, entity: :service
        end
      end

      it "returns intended methods" do
        expect(middleware.intended_methods).to eq(spec.intended_methods)
      end
    end
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Helpers::WrapMethod

      include ConvenientService::RSpec::Matchers::CallChainNext
      include ConvenientService::RSpec::Matchers::DelegateTo
      include ConvenientService::RSpec::Matchers::Results

      subject(:method_value) { method.call }

      let(:method) { wrap_method(service_instance, method_name, observe_middleware: middleware) }
      let(:method_name) { :result }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(middleware) do |middleware|
            include ConvenientService::Standard::Config

            middlewares :result do
              observe middleware
            end

            def result
              success
            end
          end
        end
      end

      let(:service_instance) { service_class.new }

      specify do
        expect { method_value }.to call_chain_next.on(method)
      end

      specify do
        expect { method_value }.to delegate_to(ConvenientService::Service::Plugins::HasJSendResult, :result?)
      end

      context "when `result` is NOT result" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(middleware) do |middleware|
              include ConvenientService::Standard::Config

              middlewares :result do
                observe middleware
              end

              def result
                "string value"
              end
            end
          end
        end

        let(:exception_message) do
          <<~TEXT
            Return value of service `#{service_class}` is NOT a `Result`.
            It is `String`.

            Did you forget to call `success`, `failure`, or `error` from the `:#{method_name}` method?
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Exceptions::ReturnValueNotKindOfResult`" do
          expect { method_value }
            .to raise_error(ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Exceptions::ReturnValueNotKindOfResult)
            .with_message(exception_message)
        end

        specify do
          expect { ignoring_exception(ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Exceptions::ReturnValueNotKindOfResult) { method_value } }
            .to delegate_to(ConvenientService, :raise)
        end
      end

      context "when `result` is result" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(middleware) do |middleware|
              include ConvenientService::Standard::Config

              middlewares :result do
                observe middleware
              end

              def result
                success
              end
            end
          end
        end

        it "returns original method value" do
          expect(method_value).to be_success.without_data
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
