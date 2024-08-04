# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code::Concern::ClassMethods, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".cast" do
      let(:casted) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.cast(other) }

      context "when `other` is NOT castable" do
        let(:other) { nil }

        it "returns `nil`" do
          expect(casted).to be_nil
        end
      end

      context "when `other` is symbol" do
        let(:other) { :foo }
        let(:code) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: other) }

        it "returns that symbol casted to code" do
          expect(casted).to eq(code)
        end
      end

      context "when `other` is string" do
        let(:other) { "foo" }
        let(:code) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: other.to_sym) }

        it "returns that string casted to code" do
          expect(casted).to eq(code)
        end
      end

      context "when `other` is code" do
        let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: :foo) }
        let(:code) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: other.value) }

        it "returns copy of `other`" do
          expect(casted).to eq(code)
        end
      end
    end

    describe ".===" do
      let(:code_class) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code }

      let(:other) { 42 }

      specify do
        expect { code_class === other }
          .to delegate_to(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code::Commands::IsCode, :call)
          .with_arguments(code: other)
      end

      it "returns `false`" do
        expect(code_class === other).to eq(false)
      end

      context "when `other` is code instance in terms of `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code::Commands::IsCode`" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success
            end
          end
        end

        let(:other) { service.result.unsafe_code }

        specify do
          expect { code_class === other }
            .to delegate_to(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code::Commands::IsCode, :call)
            .with_arguments(code: other)
        end

        it "returns `true`" do
          expect(code_class === other).to eq(true)
        end
      end

      context "when `other` is `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code` instance" do
        let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.cast(:foo) }

        it "returns `true`" do
          expect(code_class === other).to eq(true)
        end
      end

      context "when `other` is `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code` descendant instance" do
        let(:descendant_class) { Class.new(code_class) }

        let(:other) { descendant_class.cast(:foo) }

        it "returns `true`" do
          expect(code_class === other).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
