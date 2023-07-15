# frozen_string_literal: true

require "spec_helper"

RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Container do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    it { is_expected.to include_module(ConvenientService::Support::DependencyContainer::Export) }
  end

  example_group "exports" do
    include ConvenientService::RSpec::Matchers::Export

    it { is_expected.to export(:"commands.is_result?") }
  end

  example_group "instance methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    describe "#is_result?" do
      let(:user_class) do
        Class.new do
          include ConvenientService::Support::DependencyContainer::Import

          import :"commands.is_result?", from: ConvenientService::Service::Plugins::HasJSendResult::Container
        end
      end

      let(:user_instance) { user_class.new }

      let(:service) do
        Class.new do
          include ConvenientService::Configs::Standard

          def result
            success
          end
        end
      end

      let(:result) { service.result }

      specify do
        expect { user_instance.commands.is_result?(result) }
          .to delegate_to(ConvenientService::Service::Plugins::HasJSendResult::Commands::IsResult, :call)
          .with_arguments(result: result)
          .and_return_its_value
      end
    end
  end
end
