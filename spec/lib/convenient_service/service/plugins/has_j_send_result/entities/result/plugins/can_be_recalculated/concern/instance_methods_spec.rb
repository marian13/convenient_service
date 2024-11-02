# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeRecalculated::Concern::InstanceMethods, type: :standard do
  example_group "instance methods" do
    let(:service) { OpenStruct.new(recalculate_result: Object.new) }

    let(:result_class) do
      Class.new.tap do |klass|
        klass.class_exec(described_class, service) do |mod, service|
          include mod

          define_method(:service) { service }
        end
      end
    end

    let(:result_instance) { result_class.new }

    describe "#result" do
      it "delegates to `service.recalculate_result`" do
        allow(service).to receive(:recalculate_result).and_call_original

        result_instance.recalculate

        expect(service).to have_received(:recalculate_result)
      end

      it "returns return value of `service.recalculate_result`" do
        expect(result_instance.recalculate).to eq(service.recalculate_result)
      end
    end
  end
end
