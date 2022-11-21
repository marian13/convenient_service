# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::HasResultStatusCheckShortSyntax::Concern::ClassMethods do
  example_group "instance methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    before do
      allow(service_class).to receive(:result).and_return(result)
    end

    let(:service_class) do
      Class.new.tap do |klass|
        klass.class_exec(described_class) do |mod|
          include ConvenientService::Service::Plugins::HasResult::Concern

          extend mod

          def result
            success
          end
        end
      end
    end
    let(:result) { service_class.result }

    describe ".success?" do
      specify {
        expect { service_class.success? }
          .to delegate_to(result, :success?)
          .and_return_its_value
      }
    end

    describe ".error?" do
      specify {
        expect { service_class.error? }
          .to delegate_to(result, :error?)
          .and_return_its_value
      }
    end

    describe ".fail?" do
      specify {
        expect { service_class.failure? }
          .to delegate_to(result, :failure?)
          .and_return_its_value
      }
    end

    describe ".not_success?" do
      specify {
        expect { service_class.not_success? }
          .to delegate_to(result, :not_success?)
          .and_return_its_value
      }
    end

    describe ".not_error?" do
      specify {
        expect { service_class.not_error? }
          .to delegate_to(result, :not_error?)
          .and_return_its_value
      }
    end

    describe ".not_fail?" do
      specify {
        expect { service_class.not_failure? }
          .to delegate_to(result, :not_failure?)
          .and_return_its_value
      }
    end
  end
end
