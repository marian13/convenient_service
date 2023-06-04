# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message::Concern::InstanceMethods do
  include ConvenientService::RSpec::Matchers::CacheItsValue
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:message) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: value, result: result) }
  let(:value) { "foo" }
  let(:result) { double }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Copyable) }
  end

  example_group "class methods" do
    describe ".new" do
      context "when `result` is NOT passed" do
        let(:message) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: "foo") }

        it "defaults to `nil`" do
          expect(message.result).to be_nil
        end
      end
    end
  end

  example_group "instance methods" do
    example_group "attributes" do
      include ConvenientService::RSpec::Matchers::HaveAttrReader

      subject { message }

      it { is_expected.to have_attr_reader(:value) }
      it { is_expected.to have_attr_reader(:result) }
    end

    example_group "comparisons" do
      describe "#==" do
        ##
        # NOTE: Unfreezes `value` in order to have an ability to use `delegate_to` on it.
        #
        let(:value) { +"foo" }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(message == other).to be_nil
          end
        end

        context "when `other` has different `value`" do
          let(:other) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: "bar", result: result) }

          specify do
            expect { message == other }.to delegate_to(message.value, :==).with_arguments(other.value)
          end

          it "returns `false`" do
            expect(message == other).to eq(false)
          end
        end

        context "when `other` has different `result.class`" do
          let(:other) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: value, result: Object.new) }

          specify do
            expect { message == other }.to delegate_to(message.result.class, :==).with_arguments(other.result.class)
          end

          it "returns `false`" do
            expect(message == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: value, result: result) }

          it "returns `true`" do
            expect(message == other).to eq(true)
          end
        end
      end

      describe "#===" do
        ##
        # NOTE: Unfreezes `value` in order to have an ability to use `delegate_to` on it.
        #
        let(:value) { +"foo" }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(message === other).to be_nil
          end
        end

        context "when `other` has different `value`" do
          let(:other) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: "bar", result: result) }

          specify do
            expect { message === other }.to delegate_to(message.value, :===).with_arguments(other.value)
          end

          it "returns `false`" do
            expect(message === other).to eq(false)
          end
        end

        context "when `other` has different `result.class`" do
          let(:other) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: value, result: Object.new) }

          specify do
            expect { message === other }.to delegate_to(message.result.class, :==).with_arguments(other.result.class)
          end

          it "returns `false`" do
            expect(message === other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: value, result: result) }

          it "returns `true`" do
            expect(message === other).to eq(true)
          end
        end
      end
    end

    example_group "conversions" do
      describe "#to_kwargs" do
        let(:kwargs) { {value: value, result: result} }

        it "returns kwargs representation of `message`" do
          expect(message.to_kwargs).to eq(kwargs)
        end

        specify do
          expect { message.to_kwargs }.to cache_its_value
        end
      end

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
