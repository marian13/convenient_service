# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Common::Plugins::HasConfig::Concern::ClassMethods do
  let(:service_base_class) { Class.new }

  let(:service_class) do
    Class.new(service_base_class).tap do |klass|
      klass.class_exec(described_class) do |mod|
        extend mod
      end
    end
  end

  example_group "class methods" do
    describe "#config" do
      it "caches config" do
        expect(service_class.config.object_id).to eq(service_class.config.object_id)
      end

      context "when parent class does NOT have config" do
        let(:service_base_class) { Class.new }

        it "returns `ConvenientService::Common::Plugins::HasConfig::Entities::ReadOnlyConfig' instance" do
          expect(service_class.config).to be_instance_of(ConvenientService::Common::Plugins::HasConfig::Entities::ReadOnlyConfig)
        end

        it "is empty" do
          expect(service_class.config.to_h).to be_empty
        end
      end

      context "when parent class has config" do
        let(:service_base_class) do
          Class.new.tap do |klass|
            klass.class_exec(described_class) do |mod|
              extend mod
            end
          end
        end

        it "returns `ConvenientService::Common::Plugins::HasConfig::Entities::ReadOnlyConfig' instance" do
          expect(service_class.config).to be_instance_of(ConvenientService::Common::Plugins::HasConfig::Entities::ReadOnlyConfig)
        end

        it "is same as parent class config" do
          expect(service_class.config).to eq(service_class.superclass.config)
        end

        it "copies parent class config" do
          allow(service_class.superclass.config).to receive(:dup).and_call_original

          service_class.config

          expect(service_class.superclass.config).to have_received(:dup).once
        end
      end
    end

    describe "#configure" do
      context "when `block' is NOT given" do
        it "raises `LocalJumpError'" do
          expect { service_class.configure }.to raise_error(LocalJumpError)
        end
      end

      context "when `block' is given" do
        it "yields `read_default_write_config'" do
          expect { |block| service_class.configure(&block) }.to yield_with_args(service_class.config.to_read_default_write_config)
        end

        it "returns config" do
          expect(service_class.configure { |config| }).to eq(service_class.config)
        end

        it "can modify config inside block" do
          service_class.configure { |config| config.some_setting = :some_value }

          expect(service_class.config.some_setting).to eq(:some_value)
        end

        it "can modify nested config inside block" do
          service_class.configure { |config| config.some_setting.nested_setting = :some_value }

          expect(service_class.config.some_setting.nested_setting).to eq(:some_value)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
