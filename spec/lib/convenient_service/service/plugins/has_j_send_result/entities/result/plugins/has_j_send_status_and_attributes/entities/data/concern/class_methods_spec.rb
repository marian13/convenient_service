# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data::Concern::ClassMethods do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".cast" do
      let(:casted) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.cast(other) }

      context "when `other` is NOT castable" do
        let(:other) { nil }

        it "returns `nil`" do
          expect(casted).to be_nil
        end
      end

      context "when `other` is hash" do
        let(:other) { {foo: :bar} }
        let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: other) }

        it "returns that hash casted to data" do
          expect(casted).to eq(data)
        end

        context "when that hash has string keys" do
          let(:other) { {"foo" => :bar} }
          let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: {foo: :bar}) }

          it "converts string keys to symbol keys" do
            expect(casted).to eq(data)
          end
        end
      end

      context "when `other` is data" do
        let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: {foo: :bar}) }
        let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: other.value) }

        it "returns copy of `other`" do
          expect(casted).to eq(data)
        end
      end
    end

    describe ".===" do
      let(:data_class) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data }

      let(:other) { 42 }

      specify do
        expect { data_class === other }
          .to delegate_to(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data::Commands::IsData, :call)
          .with_arguments(data: other)
      end

      it "returns `false`" do
        expect(data_class === other).to eq(false)
      end

      context "when `other` is data instance in terms of `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data::Commands::IsData`" do
        let(:service) do
          Class.new do
            include ConvenientService::Service::Configs::Minimal

            def result
              success(data: {foo: :bar})
            end
          end
        end

        let(:other) { service.result.data }

        specify do
          expect { data_class === other }
            .to delegate_to(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data::Commands::IsData, :call)
            .with_arguments(data: other)
        end

        it "returns `true`" do
          expect(data_class === other).to eq(true)
        end
      end

      context "when `other` is `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data` instance" do
        let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.cast({foo: :bar}) }

        it "returns `true`" do
          expect(data_class === other).to eq(true)
        end
      end

      context "when `other` is `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data` descendant instance" do
        let(:descendant_class) { Class.new(data_class) }

        let(:other) { descendant_class.cast({foo: :bar}) }

        it "returns `true`" do
          expect(data_class === other).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
