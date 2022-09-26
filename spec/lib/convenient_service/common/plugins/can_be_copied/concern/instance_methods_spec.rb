# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Common::Plugins::CanBeCopied::Concern::InstanceMethods do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Copyable) }
  end

  example_group "instance methods" do
    let(:constructor_params) { OpenStruct.new(args: [], kwargs: {}, block: proc {}) }

    let(:service_class) do
      Class.new.tap do |klass|
        klass.class_exec(described_class, constructor_params) do |mod, constructor_params|
          include mod

          define_method(:constructor_params) { constructor_params }
        end
      end
    end

    let(:service_instance) { service_class.new }

    describe "#to_args" do
      it "delegates to `constructor_params.args`" do
        allow(constructor_params).to receive(:args).and_call_original

        service_instance.to_args

        expect(constructor_params).to have_received(:args)
      end

      it "returns return value of `constructor_params.args`" do
        expect(service_instance.to_args).to eq(constructor_params.args)
      end
    end

    describe "#to_kwargs" do
      it "delegates to `constructor_params.kwargs`" do
        allow(constructor_params).to receive(:kwargs).and_call_original

        service_instance.to_kwargs

        expect(constructor_params).to have_received(:kwargs)
      end

      it "returns return value of `constructor_params.kwargs`" do
        expect(service_instance.to_kwargs).to eq(constructor_params.kwargs)
      end
    end

    describe "#to_block" do
      it "delegates to `constructor_params.block`" do
        allow(constructor_params).to receive(:block).and_call_original

        service_instance.to_block

        expect(constructor_params).to have_received(:block)
      end

      it "returns return value of `constructor_params.block`" do
        expect(service_instance.to_block).to eq(constructor_params.block)
      end
    end
  end
end
