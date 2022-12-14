# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Common::Plugins::HasInternals::Commands::CreateInternalsClass do
  example_group "class methods" do
    describe ".call" do
      include ConvenientService::RSpec::Matchers::BeDescendantOf
      include ConvenientService::RSpec::Matchers::IncludeModule

      subject(:command_result) { described_class.call(service_class: service_class) }

      let(:service_class) { Class.new }

      context "when `service_class` does NOT have it own `Internals`" do
        let(:service_class) { Class.new }

        it "returns `Class` instance" do
          expect(command_result).to be_instance_of(Class)
        end

        it "returns `ConvenientService::Common::Plugins::HasInternals::Entities::Internals` descendant" do
          expect(command_result).to be_descendant_of(ConvenientService::Common::Plugins::HasInternals::Entities::Internals)
        end

        it "includes `ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Concern`" do
          expect(command_result).to include_module(ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Concern)
        end
      end

      context "when `service_class` has its own `Internals`" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.const_set(:Internals, Class.new)
          end
        end

        it "returns `Class` instance" do
          expect(command_result).to be_instance_of(Class)
        end

        it "returns that own `Internals`" do
          expect(command_result).to eq(service_class::Internals)
        end

        it "includes `ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Concern`" do
          expect(command_result).to include_module(ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Concern)
        end
      end

      example_group "result class" do
        let(:internals_class) { described_class.call(service_class: service_class) }

        example_group "class methods" do
          describe ".service_class" do
            it "returns `service_class` passed to `ConvenientService::Common::Plugins::HasInternals::Commands::CreateInternalsClass`" do
              expect(internals_class.service_class).to eq(service_class)
            end
          end

          describe ".==" do
            context "when `other` has different class" do
              let(:other) { 42 }

              it "returns false" do
                expect(internals_class == other).to be_nil
              end
            end

            context "when `other` has different `service_class`" do
              let(:other) { described_class.call(service_class: Class.new) }

              it "returns false" do
                expect(internals_class == other).to eq(false)
              end
            end

            context "when `other` has same attributes" do
              let(:other) { described_class.call(service_class: service_class) }

              it "returns true" do
                expect(internals_class == other).to eq(true)
              end
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
