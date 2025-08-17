# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveConnectedSteps::Middleware, type: :standard do
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
          intended_for :result, entity: :service
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

      subject(:method_value) { method.call }

      let(:method) { wrap_method(service_instance, :result, observe_middleware: middleware) }

      let(:service_instance) { service_class.new }

      context "when service has NO steps" do
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

        specify do
          expect { method_value }
            .to delegate_to(service_instance, :regular_result)
            .without_arguments
            .and_return_its_value
        end
      end

      context "when service has steps" do
        let(:first_step) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              error
            end
          end
        end

        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(first_step, middleware) do |first_step, middleware|
              include ConvenientService::Standard::Config

              middlewares :result do
                observe middleware
              end

              step first_step

              def result
                success
              end
            end
          end
        end

        specify do
          expect { method_value }
            .to delegate_to(service_instance, :steps_result)
            .without_arguments
            .and_return_its_value
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
