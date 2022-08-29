# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Common::Plugins::HasInternals::Concern do
  let(:service_class) do
    Class.new.tap do |klass|
      klass.class_exec(described_class) do |mod|
        include mod
      end
    end
  end

  let(:service_instance) { service_class.new }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }
  end

  example_group "instance methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    describe "#internals" do
      specify {
        expect { service_instance.internals }
          .to delegate_to(service_class.internals_class, :new)
          .and_return_its_value
      }

      it "caches its result" do
        expect(service_instance.internals.object_id).to eq(service_instance.internals.object_id)
      end
    end
  end

  example_group "class methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    describe ".internals_class" do
      specify {
        expect { service_class.internals_class }
          .to delegate_to(ConvenientService::Common::Plugins::HasInternals::Commands::CreateInternalsClass, :call)
          .with_arguments(service_class: service_class)
          .and_return_its_value
      }

      it "caches its result" do
        expect(service_class.internals_class.object_id).to eq(service_class.internals_class.object_id)
      end
    end
  end
end
