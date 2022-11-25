# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasInspect::Concern do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    let(:result_class) do
      Class.new.tap do |klass|
        klass.class_exec(described_class) do |mod|
          include mod
        end
      end
    end

    let(:result_instance) { result_class.new }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { result_class }

      before { result_class }

      it { is_expected.to include_module(described_class::InstanceMethods) }
    end
  end

  example_group "instance methods" do
    let(:service_class) do
      Class.new do
        def self.name
          "Service"
        end
      end
    end

    let(:service_instance) { service_class.new }

    # rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
    let(:result_class) do
      Class.new do
        include ConvenientService::Core

        concerns do
          use ConvenientService::Common::Plugins::HasInternals::Concern
          use ConvenientService::Common::Plugins::HasConstructor::Concern
          use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Concern
          use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasInspect::Concern
        end

        middlewares :initialize do
          use ConvenientService::Common::Plugins::NormalizesEnv::Middleware

          use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Middleware
        end

        class self::Internals
          include ConvenientService::Core

          concerns do
            use ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
          end
        end
      end
    end
    # rubocop:enable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock

    let(:result_instance) do
      result_class.new(
        status: :success,
        data: {},
        message: "",
        code: :default_success,
        service: service_instance
      )
    end

    describe "#inspect" do
      it "returns `inspect` representation of result" do
        expect(result_instance.inspect).to eq("<#{result_instance.service.class.name}::Result status: :#{result_instance.status}>")
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
