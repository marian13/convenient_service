# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::HasResultStatusCheckShortSyntax::Concern do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::Matchers::ExtendModule
    include ConvenientService::RSpec::Matchers::DelegateTo

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { service_class }

      before do
        allow(service_class).to receive(:result).and_return(result)
      end

      let(:result) { service_class.result }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include ConvenientService::Service::Plugins::HasResult::Concern
            include mod

            def result
              success
            end
          end
        end
      end

      specify {
        expect { service_class.success? }
          .to delegate_to(result, :success?)
          .and_return_its_value
      }

      specify {
        expect { service_class.error? }
          .to delegate_to(result, :error?)
          .and_return_its_value
      }

      specify {
        expect { service_class.failure? }
          .to delegate_to(result, :failure?)
          .and_return_its_value
      }

      specify {
        expect { service_class.not_success? }
          .to delegate_to(result, :not_success?)
          .and_return_its_value
      }

      specify {
        expect { service_class.not_error? }
          .to delegate_to(result, :not_error?)
          .and_return_its_value
      }

      specify {
        expect { service_class.not_failure? }
          .to delegate_to(result, :not_failure?)
          .and_return_its_value
      }
    end
  end
end
