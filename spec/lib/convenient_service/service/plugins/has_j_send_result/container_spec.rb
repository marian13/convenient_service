# frozen_string_literal: true

require "spec_helper"

RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Container, type: :standard do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    it { is_expected.to include_module(ConvenientService::Support::DependencyContainer::Export) }
  end

  example_group "exports" do
    include ConvenientService::RSpec::Matchers::Export

    it { is_expected.to export(:"commands.is_result?") }
    it { is_expected.to export(:"constants.DEFAULT_SUCCESS_CODE") }
    it { is_expected.to export(:"constants.DEFAULT_FAILURE_CODE") }
    it { is_expected.to export(:"constants.DEFAULT_ERROR_CODE") }
  end

  example_group "instance methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    describe "#commands#is_result?" do
      let(:user_class) do
        Class.new do
          include ConvenientService::Support::DependencyContainer::Import

          import :"commands.is_result?", from: ConvenientService::Service::Plugins::HasJSendResult::Container
        end
      end

      let(:user_instance) { user_class.new }

      let(:service) do
        Class.new do
          include ConvenientService::Service::Configs::Standard

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

    describe "#constants#DEFAULT_SUCCESS_CODE" do
      let(:user_class) do
        Class.new do
          include ConvenientService::Support::DependencyContainer::Import

          import :"constants.DEFAULT_SUCCESS_CODE", from: ConvenientService::Service::Plugins::HasJSendResult::Container
        end
      end

      let(:user_instance) { user_class.new }

      specify do
        expect(user_instance.constants.DEFAULT_SUCCESS_CODE).to eq(ConvenientService::Service::Plugins::HasJSendResult::Constants::DEFAULT_SUCCESS_CODE)
      end
    end

    describe "#constants#DEFAULT_FAILURE_CODE" do
      let(:user_class) do
        Class.new do
          include ConvenientService::Support::DependencyContainer::Import

          import :"constants.DEFAULT_FAILURE_CODE", from: ConvenientService::Service::Plugins::HasJSendResult::Container
        end
      end

      let(:user_instance) { user_class.new }

      specify do
        expect(user_instance.constants.DEFAULT_FAILURE_CODE).to eq(ConvenientService::Service::Plugins::HasJSendResult::Constants::DEFAULT_FAILURE_CODE)
      end
    end

    describe "#constants#DEFAULT_ERROR_CODE" do
      let(:user_class) do
        Class.new do
          include ConvenientService::Support::DependencyContainer::Import

          import :"constants.DEFAULT_ERROR_CODE", from: ConvenientService::Service::Plugins::HasJSendResult::Container
        end
      end

      let(:user_instance) { user_class.new }

      specify do
        expect(user_instance.constants.DEFAULT_ERROR_CODE).to eq(ConvenientService::Service::Plugins::HasJSendResult::Constants::DEFAULT_ERROR_CODE)
      end
    end
  end
end
