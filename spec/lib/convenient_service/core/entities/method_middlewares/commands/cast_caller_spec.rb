# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Core::Entities::MethodMiddlewares::Commands::CastCaller do
  example_group "class methhods" do
    describe ".call" do
      let(:casted) { described_class.call(other: other) }

      let(:entity) { double }

      context "when `other` is NOT castable" do
        let(:other) { 42 }

        it "returns `nil`" do
          expect(casted).to be_nil
        end
      end

      context "when `other` is hash" do
        context "when `other` does NOT have `:entity` key" do
          let(:other) { {} }

          it "returns `nil`" do
            expect(casted).to be_nil
          end
        end

        context "when `other` has `:entity` key" do
          context "when `other` does NOT have `:scope` key" do
            let(:other) { {entity: entity} }

            it "returns `nil`" do
              expect(casted).to be_nil
            end
          end

          context "when `other` has `:scope` key" do
            context "when value by `:scope` key is NOT castable" do
              let(:other) { {entity: entity, scope: 42} }

              it "returns `nil`" do
                expect(casted).to be_nil
              end
            end

            context "when value by `:scope` key is `:instance`" do
              let(:other) { {entity: entity, scope: :instance} }

              it "returns hash casted to caller" do
                expect(casted).to eq(ConvenientService::Core::Entities::MethodMiddlewares::Entities::Callers::Instance.new(entity: entity))
              end
            end

            context "when value by `:scope` key is `:class`" do
              let(:other) { {entity: entity, scope: :class} }

              it "returns hash casted to caller" do
                expect(casted).to eq(ConvenientService::Core::Entities::MethodMiddlewares::Entities::Callers::Class.new(entity: entity))
              end
            end
          end
        end
      end

      context "when `other` is caller" do
        let(:other) { described_class.call(other: {entity: entity, scope: :instance}) }

        it "returns `caller` copy" do
          expect(casted).to eq(other.copy)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
