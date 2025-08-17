# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service::Concern::ClassMethods, type: :standard do
  include ConvenientService::RSpec::Matchers::CacheItsValue

  let(:service_class) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service }

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
          expect { service_class.cast(other) }.not_to cache_its_value
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
