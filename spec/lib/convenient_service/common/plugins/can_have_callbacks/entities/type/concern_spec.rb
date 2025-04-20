# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Type::Concern, type: :standard do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    include ConvenientService::RSpec::PrimitiveMatchers::ExtendModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { service_class }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to extend_module(described_class::ClassMethods) }
    end
  end

  example_group "class methods" do
    describe ".cast" do
      let(:type_class) { ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Type }

      context "when `other` is NOT castable" do
        let(:other) { 42 }

        it "returns nil" do
          expect(type_class.cast(other)).to be_nil
        end
      end

      context "when `other` is castable" do
        context "when `other` is string" do
          let(:other) { "before" }

          it "returns that string casted to `type`" do
            expect(type_class.cast(other)).to eq(ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Type.new(value: :before))
          end

          it "casts that string to symbol" do
            expect(type_class.cast(other).value).to eq(:before)
          end
        end

        context "when `other` is symbol" do
          let(:other) { :before }

          it "returns that string casted to `type`" do
            expect(type_class.cast(other)).to eq(ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Type.new(value: :before))
          end
        end

        context "when `other` is `ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Type`" do
          let(:other) { ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Type.new(value: :before) }

          it "returns that type casted to `type`" do
            expect(type_class.cast(other)).to eq(ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Type.new(value: :before))
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
