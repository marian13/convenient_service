# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasResultShortSyntax::Concern::InstanceMethods do
  example_group "instance methods" do
    let(:data_class) do
      Class.new do
        def [](key)
          "return value"
        end
      end
    end

    let(:data_instance) { data_class.new }

    let(:result_class) do
      Class.new.tap do |klass|
        klass.class_exec(described_class, data_instance) do |mod, data_instance|
          include mod

          define_method(:data) { data_instance }
        end
      end
    end

    let(:result_instance) { result_class.new }

    let(:key) { :foo }

    describe "#result" do
      it "delegates to `data[key]'" do
        allow(data_instance).to receive(:[]).with(key).and_call_original

        result_instance[key]

        expect(data_instance).to have_received(:[])
      end

      it "returns return value of `data[key]'" do
        expect(result_instance[key]).to eq(data_instance[key])
      end
    end
  end
end
