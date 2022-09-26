# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Common::Plugins::HasAroundCallbacks::Concern::ClassMethods do
  let(:service_class) do
    Class.new.tap do |klass|
      klass.class_exec(described_class) do |mod|
        include ConvenientService::Common::Plugins::HasCallbacks::Concern

        extend mod
      end
    end
  end

  let(:type) { :result }
  let(:block) { proc {} }

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
