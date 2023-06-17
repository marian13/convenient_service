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
    let(:constructor_arguments) { OpenStruct.new(args: [], kwargs: {}, block: proc {}) }

    let(:service_class) do
      Class.new.tap do |klass|
        klass.class_exec(described_class, constructor_arguments) do |mod, constructor_arguments|
          include mod

          define_method(:constructor_arguments) { constructor_arguments }
        end
      end
    end

    let(:service_instance) { service_class.new }

    describe "#to_args" do
      it "delegates to `constructor_arguments.args`" do
        allow(constructor_arguments).to receive(:args).and_call_original

        service_instance.to_args

        expect(constructor_arguments).to have_received(:args)
      end

      it "returns return value of `constructor_arguments.args`" do
        expect(service_instance.to_args).to eq(constructor_arguments.args)
      end
    end

    describe "#to_kwargs" do
      it "delegates to `constructor_arguments.kwargs`" do
        allow(constructor_arguments).to receive(:kwargs).and_call_original

        service_instance.to_kwargs

        expect(constructor_arguments).to have_received(:kwargs)
      end

      it "returns return value of `constructor_arguments.kwargs`" do
        expect(service_instance.to_kwargs).to eq(constructor_arguments.kwargs)
      end
    end

    describe "#to_block" do
      it "delegates to `constructor_arguments.block`" do
        allow(constructor_arguments).to receive(:block).and_call_original

        service_instance.to_block

        expect(constructor_arguments).to have_received(:block)
      end

      it "returns return value of `constructor_arguments.block`" do
        expect(service_instance.to_block).to eq(constructor_arguments.block)
      end
    end
  end
end
