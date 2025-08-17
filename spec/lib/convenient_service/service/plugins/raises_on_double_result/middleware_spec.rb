# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::RaisesOnDoubleResult::Middleware, type: :standard do
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
          intended_for :regular_result, entity: :service
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

      subject(:method_value) { method.call }

      let(:method) { wrap_method(service_instance, :regular_result, observe_middleware: middleware) }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(middleware) do |middleware|
            include ConvenientService::Standard::Config

            middlewares :regular_result do
              use_and_observe middleware
            end

            def result
              success
            end
          end
        end
      end

      let(:service_instance) { service_class.new }

      let(:key) { ConvenientService::Service::Plugins::RaisesOnDoubleResult::Entities::Key.new(method: :regular_result, args: [], kwargs: {}, block: nil) }

      context "when service does NOT have result" do
        before do
          service_instance.internals.cache.delete(:has_j_send_result)
        end

        specify do
          expect { method_value }
            .to delegate_to(service_instance.internals.cache, :write)
            .with_arguments(:has_j_send_result, true)
        end

        specify do
          expect { method_value }
            .to call_chain_next.on(method)
            .and_return_its_value
        end
      end

      context "when service has result" do
        include ConvenientService::RSpec::Helpers::IgnoringException

        before do
          service_instance.internals.cache.write(:has_j_send_result, true)
        end

        let(:exception_message) do
          <<~TEXT
            `#{service_class}` service has a double result.

            Make sure its #result calls only one from the following methods `success`, `failure`, or `error` and only once.

            Maybe you missed `return`? The most common scenario is similar to this one:

            def result
              # ...

              error unless valid?
              # instead of return error unless valid?

              success
            end
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::RaisesOnDoubleResult::Exceptions::DoubleResult`" do
          expect { method_value }
            .to raise_error(ConvenientService::Service::Plugins::RaisesOnDoubleResult::Exceptions::DoubleResult)
            .with_message(exception_message)
        end

        specify do
          expect { ignoring_exception(ConvenientService::Service::Plugins::RaisesOnDoubleResult::Exceptions::DoubleResult) { method_value } }
            .to delegate_to(ConvenientService, :raise)
        end

        ##
        # NOTE: Error is NOT the purpose of this spec. That is why it is caught.
        # But if it is NOT caught, the spec should fail.
        #
        specify do
          expect { ignoring_exception(ConvenientService::Service::Plugins::RaisesOnDoubleResult::Exceptions::DoubleResult) { method_value } }
            .not_to call_chain_next.on(method)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
