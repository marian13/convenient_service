# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Commands::CastMethod do
  example_group "class methods" do
    describe ".call" do
      let(:other) { :foo }
      let(:options) { {direction: :input} }

      let(:casted) { described_class.call(other: other, options: options) }

      context "when `key` is NOT castable" do
        before do
          allow(ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Commands::CastMethodKey).to receive(:call).and_return(nil)
        end

        it "returns `nil`" do
          expect(casted).to be_nil
        end
      end

      context "when `key` is castable" do
        context "when `name` is NOT castable" do
          before do
            allow(ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Commands::CastMethodName).to receive(:call).and_return(nil)
          end

          it "returns `nil`" do
            expect(casted).to be_nil
          end
        end

        context "when `name` is castable" do
          context "when `caller` is NOT castable" do
            before do
              allow(ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Commands::CastMethodCaller).to receive(:call).and_return(nil)
            end

            it "returns `nil`" do
              expect(casted).to be_nil
            end
          end

          context "when `caller` is castable" do
            context "when `direction` is NOT castable" do
              before do
                allow(ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Commands::CastMethodDirection).to receive(:call).and_return(nil)
              end

              it "returns `nil`" do
                expect(casted).to be_nil
              end
            end

            context "when `direction` is castable" do
              let(:method) do
                ConvenientService::Service::Plugins::HasResultSteps::Entities::Method.new(
                  key: ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Commands::CastMethodKey.call(other: other, options: options),
                  name: ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Commands::CastMethodName.call(other: other, options: options),
                  caller: ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Commands::CastMethodCaller.call(other: other, options: options),
                  direction: ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Commands::CastMethodDirection.call(other: other, options: options)
                )
              end

              it "returns method" do
                expect(casted).to eq(method)
              end
            end
          end
        end
      end

      context "when `other` is method" do
        let(:other) { ConvenientService::Service::Plugins::HasResultSteps::Entities::Method.cast(:foo, direction: :input) }

        it "returns its copy" do
          expect(casted).to eq(other.copy)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
