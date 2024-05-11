# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Helpers::StubService, type: :standard do
  include ConvenientService::RSpec::PrimitiveMatchers::DelegateTo

  example_group "instance methods" do
    let(:klass) do
      Class.new.tap do |klass|
        klass.class_exec(described_class) do |mod|
          include mod
        end
      end
    end

    let(:instance) { klass.new }

    describe "#stub_service" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Service::Configs::Standard
        end
      end

      specify do
        expect { instance.stub_service(service_class) }
          .to delegate_to(ConvenientService::RSpec::Helpers::Classes::StubService, :new)
          .with_arguments(service_class)
      end
    end

    describe "#return_result" do
      let(:status) { :success }

      specify do
        expect { instance.return_result(status) }
          .to delegate_to(ConvenientService::RSpec::Helpers::Classes::StubService::Entities::ResultSpec, :new)
          .with_arguments(status: status)
      end
    end

    describe "#return_success" do
      specify do
        expect { instance.return_success }
          .to delegate_to(ConvenientService::RSpec::Helpers::Classes::StubService::Entities::ResultSpec, :new)
          .with_arguments(status: :success)
      end
    end

    describe "#return_failure" do
      specify do
        expect { instance.return_failure }
          .to delegate_to(ConvenientService::RSpec::Helpers::Classes::StubService::Entities::ResultSpec, :new)
          .with_arguments(status: :failure)
      end
    end

    describe "#return_error" do
      specify do
        expect { instance.return_error }
          .to delegate_to(ConvenientService::RSpec::Helpers::Classes::StubService::Entities::ResultSpec, :new)
          .with_arguments(status: :error)
      end
    end
  end
end
