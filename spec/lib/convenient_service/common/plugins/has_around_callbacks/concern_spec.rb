# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Common::Plugins::HasAroundCallbacks::Concern do
  let(:service_class) do
    Class.new do
      include ConvenientService::Service::Configs::Standard
    end
  end

  let(:type) { :result }
  let(:block) { proc {} }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::PrimitiveMatchers::ExtendModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { service_class }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to extend_module(described_class::ClassMethods) }
    end
  end

  example_group "class methods" do
    describe ".around" do
      let(:callback) { ConvenientService::Common::Plugins::HasCallbacks::Entities::Callback.new(types: [:around, type], block: block) }

      it "adds around callback to `callbacks`" do
        service_class.around(type, &block)

        expect(service_class.callbacks).to include(callback)
      end

      it "returns around callback" do
        expect(service_class.around(type, &block)).to eq(callback)
      end
    end
  end
end
