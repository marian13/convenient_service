# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Concern::ClassMethods, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".cast" do
      let(:casted) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status.cast(other) }

      context "when `other` is NOT castable" do
        let(:other) { nil }

        it "returns nil" do
          expect(casted).to be_nil
        end
      end

      context "when `other` is symbol" do
        let(:other) { :foo }
        let(:status) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status.new(value: other) }

        it "returns that symbol casted to status" do
          expect(casted).to eq(status)
        end
      end

      context "when `other` is string" do
        let(:other) { "foo" }
        let(:status) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status.new(value: other.to_sym) }

        it "returns that string casted to status" do
          expect(casted).to eq(status)
        end
      end

      context "when `other` is status" do
        let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status.new(value: :foo) }
        let(:status) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status.new(value: other.value) }

        it "returns copy of `other`" do
          expect(casted).to eq(status)
        end
      end
    end

    describe ".===" do
      let(:status_class) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status }

      let(:other) { 42 }

      specify do
        expect { status_class === other }
          .to delegate_to(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Commands::IsStatus, :call)
          .with_arguments(status: other)
      end

      it "returns `false`" do
        expect(status_class === other).to eq(false)
      end

      context "when `other` is status instance in terms of `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Commands::IsStatus`" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success
            end
          end
        end

        let(:other) { service.result.status }

        specify do
          expect { status_class === other }
            .to delegate_to(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Commands::IsStatus, :call)
            .with_arguments(status: other)
        end

        it "returns `true`" do
          expect(status_class === other).to eq(true)
        end
      end

      context "when `other` is `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status` instance" do
        let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status.cast(:success) }

        it "returns `true`" do
          expect(status_class === other).to eq(true)
        end
      end

      context "when `other` is `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status` descendant instance" do
        let(:descendant_class) { Class.new(status_class) }

        let(:other) { descendant_class.cast(:success) }

        it "returns `true`" do
          expect(status_class === other).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
