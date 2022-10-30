# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller::Commands::CastCaller do
  example_group "class methhods" do
    describe ".call" do
      let(:casted) { described_class.call(other: other) }
      let(:scope) { :instance }
      let(:klass) { Class.new }

      context "when `other` is NOT castable" do
        let(:other) { 42 }

        it "returns `nil`" do
          expect(casted).to be_nil
        end
      end

      context "when `other` is hash" do
        context "when that hash has no `:scope` key" do
          let(:other) { {} }

          it "returns `nil`" do
            expect(casted).to be_nil
          end
        end

        context "when that hash has `:scope` key" do
          context "when value by `:scope` key is NOT castable" do
            let(:other) { {scope: 42} }

            it "returns `nil`" do
              expect(casted).to be_nil
            end
          end

          context "when value by `:scope` key is `:instance`" do
            let(:other) { {scope: :instance} }
            let(:prefix) { ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller::INSTANCE_PREFIX }

            it "returns other casted to caller" do
              expect(casted).to eq(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller.new(prefix: prefix))
            end
          end

          context "when value by `:scope` key is `:class`" do
            let(:other) { {scope: :class} }
            let(:prefix) { ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller::CLASS_PREFIX }

            it "returns other casted to caller" do
              expect(casted).to eq(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller.new(prefix: prefix))
            end
          end
        end
      end

      context "when `other` is caller" do
        let(:other) { ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller.cast({scope: scope, klass: klass}) }

        it "returns caller copy" do
          expect(casted).to eq(other.copy)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
