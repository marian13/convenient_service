# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data::Concern::InstanceMethods do
  include ConvenientService::RSpec::Matchers::CacheItsValue
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:data) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }
  let(:value) { {foo: :bar} }
  let(:result) { double }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Copyable) }
  end

  example_group "class methods" do
    describe ".new" do
      context "when `result` is NOT passed" do
        let(:data) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: {foo: :bar}) }

        it "defaults to `nil`" do
          expect(data.result).to be_nil
        end
      end
    end
  end

  example_group "instance methods" do
    example_group "attributes" do
      include ConvenientService::RSpec::Matchers::HaveAttrReader

      subject { data }

      it { is_expected.to have_attr_reader(:value) }
      it { is_expected.to have_attr_reader(:result) }
    end

    describe "#has_attribute?" do
      context "when `data` has NO attribute by key" do
        let(:value) { {} }

        it "returns `false`" do
          expect(data.has_attribute?(:foo)).to eq(false)
        end

        context "when key is string" do
          it "converts that key to symbol" do
            expect(data.has_attribute?("foo")).to eq(false)
          end
        end
      end

      context "when `data` has attribute by key" do
        let(:value) { {foo: :bar} }

        it "returns `true`" do
          expect(data.has_attribute?(:foo)).to eq(true)
        end

        context "when key is string" do
          it "converts that key to symbol" do
            expect(data.has_attribute?("foo")).to eq(true)
          end
        end
      end
    end

    describe "#[]" do
      it "returns `data` attribute by string key" do
        expect(data["foo"]).to eq(:bar)
      end

      it "returns `data` attribute by symbol key" do
        expect(data[:foo]).to eq(:bar)
      end

      context "when NO `data` attribute exist for passed key" do
        let(:error_message) do
          <<~TEXT
            Data attribute `abc` does NOT exist. Make sure the corresponding result returns it.
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Errors::NotExistingAttribute`" do
          expect { data[:abc] }
            .to raise_error(ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Errors::NotExistingAttribute)
            .with_message(error_message)
        end
      end
    end

    example_group "comparisons" do
      describe "#==" do
        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(data == other).to be_nil
          end
        end

        context "when `other` has different `value`" do
          let(:other) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: {foo: :baz}, result: result) }

          specify do
            expect { data == other }.to delegate_to(data.value, :==).with_arguments(other.value)
          end

          it "returns `false`" do
            expect(data == other).to eq(false)
          end

          context "when value is described by RSpec argument matcher" do
            let(:other) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: instance_of(Hash), result: result) }

            it "does NOT respect that RSpec argument matcher" do
              expect(data == other).to eq(false)
            end
          end
        end

        context "when `other` has different `result.class`" do
          let(:other) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: Object.new) }

          specify do
            expect { data == other }.to delegate_to(data.result.class, :==).with_arguments(other.result.class)
          end

          it "returns `false`" do
            expect(data == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }

          it "returns `true`" do
            expect(data == other).to eq(true)
          end
        end
      end

      describe "#===" do
        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(data === other).to be_nil
          end
        end

        context "when `other` has different `value`" do
          let(:other) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: {foo: :baz}, result: result) }

          specify do
            expect { data === other }.to delegate_to(other.value, :===).with_arguments(data.value)
          end

          it "returns `false`" do
            expect(data === other).to eq(false)
          end

          context "when value is described by RSpec argument matcher" do
            let(:other) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: instance_of(Hash), result: result) }

            it "respects that RSpec argument matcher" do
              expect(data === other).to eq(true)
            end
          end
        end

        context "when `other` has different `result.class`" do
          let(:other) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: Object.new) }

          specify do
            expect { data === other }.to delegate_to(data.result.class, :==).with_arguments(other.result.class)
          end

          it "returns `false`" do
            expect(data === other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }

          it "returns `true`" do
            expect(data === other).to eq(true)
          end
        end
      end
    end

    example_group "conversions" do
      describe "#to_h" do
        it "returns hash representation of `data`" do
          expect(data.to_h).to eq({foo: :bar})
        end

        specify do
          expect { data.to_h }.to cache_its_value
        end
      end

      describe "#to_kwargs" do
        let(:kwargs) { {value: value, result: result} }

        it "returns kwargs representation of `data`" do
          expect(data.to_kwargs).to eq(kwargs)
        end

        specify do
          expect { data.to_kwargs }.to cache_its_value
        end
      end

      describe "#to_s" do
        it "returns string representation of `data`" do
          expect { data.to_s }
            .to delegate_to(data.to_h, :to_s)
            .without_arguments
            .and_return_its_value
        end

        specify do
          expect { data.to_s }.to cache_its_value
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
