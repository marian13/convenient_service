# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::CanRecalculateResult::Concern::InstanceMethods do
  example_group "instance methods" do
    let(:service_class) do
      Class.new.tap do |klass|
        klass.class_exec(described_class, service_instance_result, service_instance_copy) do |mod, service_instance_result, service_instance_copy|
          include mod

          define_method(:result) { service_instance_result }
          define_method(:copy) { service_instance_copy }
        end
      end
    end

    let(:service_instance) { service_class.new }
    let(:service_instance_result) { double }
    let(:service_instance_copy) { OpenStruct.new(result: service_instance_copy_result) }
    let(:service_instance_copy_result) { double }

    describe "#recalculate_result" do
      it "delegates to `copy`" do
        allow(service_instance).to receive(:copy).and_call_original

        service_instance.recalculate_result

        expect(service_instance).to have_received(:copy)
      end

      it "delegates to `result`" do
        allow(service_instance_copy).to receive(:result).and_call_original

        service_instance.recalculate_result

        expect(service_instance_copy).to have_received(:result)
      end

      it "returns return value of `copy.result`" do
        expect(service_instance.recalculate_result).to eq(service_instance_copy_result)
      end
    end
  end
end
