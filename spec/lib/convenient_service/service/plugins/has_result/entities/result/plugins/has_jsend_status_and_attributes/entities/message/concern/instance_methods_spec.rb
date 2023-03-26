# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Message::Concern::InstanceMethods do
  include ConvenientService::RSpec::Matchers::CacheItsValue
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:message) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Message.cast(value) }
  let(:value) { "foo" }

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { message }

    it { is_expected.to have_attr_reader(:value) }
  end

  example_group "instance methods" do
    example_group "comparisons" do
      describe "#==" do
        context "when `other` is NOT castable" do
          let(:other) { 42 }

          before do
            allow(message).to receive(:cast).and_return(nil)
          end

          it "returns `nil`" do
            expect(message == other).to be_nil
          end
        end

        context "when `other` is castable" do
          context "when `other` has different `value`" do
            let(:other) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Message.cast("bar") }

            before do
              allow(message).to receive(:cast).and_return(other)
            end

            it "returns `false`" do
              expect(message == other).to eq(false)
            end
          end

          context "when `other` has same `value`" do
            let(:other) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Message.cast("foo") }

            before do
              allow(message).to receive(:cast).and_return(other)
            end

            it "returns `true`" do
              expect(message == other).to eq(true)
            end
          end
        end
      end
    end

    example_group "conversions" do
      describe "#to_s" do
        it "returns string representation of `message`" do
          expect(message.to_s).to eq("foo")
        end

        specify do
          expect { message.to_s }.to cache_its_value
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
