# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResultSteps::Entities::Service::ClassMethods do
  let(:service_class) { ConvenientService::Service::Plugins::HasResultSteps::Entities::Service }

  example_group "class methods" do
    describe "#cast" do
      context "when `other` is NOT castable" do
        let(:other) { nil }

        it "returns `nil`" do
          expect(service_class.cast(other)).to be_nil
        end
      end

      context "when `other` is klass" do
        let(:klass) { Class.new }
        let(:other) { klass }

        it "returns that klass casted to service" do
          expect(service_class.cast(other)).to eq(service_class.new(klass))
        end
      end

      context "when `other` is service" do
        let(:klass) { Class.new }
        let(:other) { service_class.new(klass) }

        it "returns that service casted to service" do
          expect(service_class.cast(other)).to eq(service_class.new(klass))
        end

        it "returns new service instance" do
          expect(service_class.cast(other).object_id).not_to eq(other.object_id)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
