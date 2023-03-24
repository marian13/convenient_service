# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Commands::CastMethodFactory do
  example_group "class methods" do
    describe ".call" do
      let(:casted) { described_class.call(other: other) }

      context "when `other` is NOT castable" do
        let(:other) { 42 }

        it "returns `nil`" do
          expect(casted).to be_nil
        end
      end

      context "when `other` is symbol" do
        let(:other) { :foo }

        it "returns symbol factory" do
          expect(casted).to eq(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Factories::Symbol.new(other: other))
        end
      end

      context "when `other` is string" do
        let(:other) { "foo" }

        it "returns string factory" do
          expect(casted).to eq(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Factories::String.new(other: other))
        end
      end

      context "when `other` is hash" do
        context "when that hash has no keys" do
          let(:other) { {} }

          it "returns `nil`" do
            expect(casted).to be_nil
          end
        end

        context "when that hash has one key" do
          context "when value by that key is NOT castable" do
            let(:other) { {foo: 42} }

            it "returns `nil`" do
              expect(casted).to be_nil
            end
          end

          context "when value by that key is symbol" do
            let(:other) { {foo: :bar} }

            it "returns hash with symbol value factory" do
              expect(casted).to eq(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Factories::Hash::SymbolValue.new(other: other))
            end
          end

          context "when value by that key is string" do
            let(:other) { {foo: "bar"} }

            it "returns hash with string value factory" do
              expect(casted).to eq(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Factories::Hash::StringValue.new(other: other))
            end
          end

          context "when value by that key is proc" do
            let(:proc) { -> { :bar } }
            let(:other) { {foo: proc} }

            it "returns hash with proc value factory" do
              expect(casted).to eq(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Factories::Hash::ProcValue.new(other: other))
            end
          end

          context "when value by that key is raw value" do
            let(:raw_value) { ConvenientService::Support::RawValue.wrap(:bar) }
            let(:other) { {foo: raw_value} }

            it "returns hash with raw value factory" do
              expect(casted).to eq(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Factories::Hash::RawValue.new(other: other))
            end
          end

          context "when value by that key is reassignment" do
            let(:reassignment) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Values::Reassignment.new(:bar) }
            let(:other) { {foo: reassignment} }

            it "returns hash with reassignment value factory" do
              expect(casted).to eq(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Factories::Hash::ReassignmentValue.new(other: other))
            end
          end
        end

        context "when that hash has multiple keys" do
          let(:other) { {foo: :bar, baz: :qux} }

          it "returns `nil`" do
            expect(casted).to be_nil
          end
        end
      end

      context "when `other` is reassignment" do
        let(:reassignment) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Values::Reassignment.new("foo") }
        let(:other) { reassignment }

        it "returns hash with reassignment value factory" do
          expect(casted).to eq(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Factories::Reassignment.new(other: other))
        end
      end

      context "when `other` is method" do
        let(:other) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method.cast(:foo, direction: :input) }

        it "returns hash with reassignment value factory" do
          expect(casted).to eq(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Factories::Method.new(other: other))
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
