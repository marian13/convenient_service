# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Common::Plugins::HasCallbacks::Concern::ClassMethods do
  let(:service_class) do
    Class.new.tap do |klass|
      klass.class_exec(described_class) do |mod|
        extend mod
      end
    end
  end

  let(:type) { :result }
  let(:block) { proc {} }

  example_group "class methods" do
    describe ".callbacks" do
      it "returns `ConvenientService::Common::Plugins::HasCallbacks::Entities::CallbackCollection' instance" do
        expect(service_class.callbacks).to eq(ConvenientService::Common::Plugins::HasCallbacks::Entities::CallbackCollection.new)
      end
    end

    describe ".before" do
      let(:callback) { ConvenientService::Common::Plugins::HasCallbacks::Entities::Callback.new(types: [:before, type], block: block) }

      it "adds before callback to `callbacks'" do
        service_class.before(type, &block)

        expect(service_class.callbacks).to include(callback)
      end

      it "returns before callback" do
        expect(service_class.before(type, &block)).to eq(callback)
      end
    end

    describe ".after" do
      let(:callback) { ConvenientService::Common::Plugins::HasCallbacks::Entities::Callback.new(types: [:after, type], block: block) }

      it "adds after callback to `callbacks'" do
        service_class.after(type, &block)

        expect(service_class.callbacks).to include(callback)
      end

      it "returns after callback" do
        expect(service_class.after(type, &block)).to eq(callback)
      end
    end
  end
end
