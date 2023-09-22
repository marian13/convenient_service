# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::HasJSendResultStatusCheckShortSyntax::Concern::ClassMethods do
  example_group "instance methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    let(:service_class) do
      Class.new do
        include ConvenientService::Service::Configs::Standard

        def result
          success
        end
      end
    end

    let(:result) { service_class.result }

    before do
      allow(service_class).to receive(:result).and_return(result)
    end

    describe ".success?" do
      specify do
        expect { service_class.success? }
          .to delegate_to(result, :success?)
          .and_return_its_value
      end
    end

    describe ".ok?" do
      specify do
        expect { service_class.ok? }
          .to delegate_to(result, :success?)
          .and_return_its_value
      end
    end

    describe ".error?" do
      specify do
        expect { service_class.error? }
          .to delegate_to(result, :error?)
          .and_return_its_value
      end
    end

    describe ".failure?" do
      specify do
        expect { service_class.failure? }
          .to delegate_to(result, :failure?)
          .and_return_its_value
      end
    end

    describe ".not_ok?" do
      specify do
        expect { service_class.not_ok? }
          .to delegate_to(result, :not_success?)
          .and_return_its_value
      end
    end

    describe ".not_success?" do
      specify do
        expect { service_class.not_success? }
          .to delegate_to(result, :not_success?)
          .and_return_its_value
      end
    end

    describe ".not_error?" do
      specify do
        expect { service_class.not_error? }
          .to delegate_to(result, :not_error?)
          .and_return_its_value
      end
    end

    describe ".not_fail?" do
      specify do
        expect { service_class.not_failure? }
          .to delegate_to(result, :not_failure?)
          .and_return_its_value
      end
    end
  end
end
