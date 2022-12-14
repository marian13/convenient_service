# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Commands::CastMethodKey do
  example_group "class methods" do
    describe ".call" do
      let(:options) { double }
      let(:casted) { described_class.call(other: other, options: options) }

      context "when `other` is NOT castable" do
        let(:other) { 42 }

        it "returns `nil`" do
          expect(casted).to be_nil
        end
      end

      context "when `other` is symbol" do
        let(:other) { :foo }

        it "returns symbol casted to method key" do
          expect(casted).to eq(ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Entities::Key.new(other))
        end
      end

      context "when `other` is string" do
        let(:other) { "foo" }

        it "returns string casted to method key" do
          expect(casted).to eq(ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Entities::Key.new(other))
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

            it "returns proc casted to method key" do
              expect(casted).to eq(ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Entities::Key.new(:foo))
            end
          end

          context "when value by that key is string" do
            let(:other) { {foo: "bar"} }

            it "returns proc casted to method key" do
              expect(casted).to eq(ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Entities::Key.new(:foo))
            end
          end

          context "when value by that key is proc" do
            let(:other) { {foo: -> { :bar }} }

            it "returns proc casted to method key" do
              expect(casted).to eq(ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Entities::Key.new(:foo))
            end
          end

          context "when value by that key is raw value" do
            let(:other) { {foo: ConvenientService::Support::RawValue.wrap(:bar)} }

            it "returns raw value casted to method key" do
              expect(casted).to eq(ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Entities::Key.new(:foo))
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

      context "when `other` is method" do
        let(:other) { ConvenientService::Service::Plugins::HasResultSteps::Entities::Method.cast(:foo, direction: :input) }

        it "returns its key copy" do
          expect(casted).to eq(other.key.copy)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
