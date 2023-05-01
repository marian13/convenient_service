# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code::Concern::InstanceMethods do
  include ConvenientService::RSpec::Matchers::CacheItsValue

  let(:code) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: value, result: result) }
  let(:value) { :foo }
  let(:result) { double }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Copyable) }
  end

  example_group "class methods" do
    describe ".new" do
      context "when `result` is NOT passed" do
        let(:code) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: :foo) }

        it "defaults to `nil`" do
          expect(code.result).to be_nil
        end
      end
    end
  end

  example_group "instance methods" do
    example_group "attributes" do
      include ConvenientService::RSpec::Matchers::HaveAttrReader

      subject { code }

      it { is_expected.to have_attr_reader(:value) }
      it { is_expected.to have_attr_reader(:result) }
    end

    example_group "comparisons" do
      describe "#==" do
        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(code == other).to be_nil
          end
        end

        context "when `other` has different `value`" do
          let(:other) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: :bar, result: result) }

          it "returns `false`" do
            expect(code == other).to eq(false)
          end
        end

        context "when `other` has different `result.class`" do
          let(:other) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: value, result: Object.new) }

          it "returns `false`" do
            expect(code == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: value, result: result) }

          it "returns `true`" do
            expect(code == other).to eq(true)
          end
        end
      end
    end

    example_group "conversions" do
      describe "#to_kwargs" do
        let(:kwargs) { {value: value, result: result} }

        it "returns kwargs representation of `code`" do
          expect(code.to_kwargs).to eq(kwargs)
        end

        specify do
          expect { code.to_kwargs }.to cache_its_value
        end
      end

      describe "#to_s" do
        it "returns string representation of `code`" do
          expect(code.to_s).to eq("foo")
        end

        specify do
          expect { code.to_s }.to cache_its_value
        end
      end

      describe "#to_sym" do
        it "returns symbol representation of `code`" do
          expect(code.to_sym).to eq(:foo)
        end

        specify do
          expect { code.to_sym }.to cache_its_value
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
