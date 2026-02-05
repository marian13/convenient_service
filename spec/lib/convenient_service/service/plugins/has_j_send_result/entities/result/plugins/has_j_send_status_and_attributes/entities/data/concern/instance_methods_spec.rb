# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data::Concern::InstanceMethods, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::CacheItsValue
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }
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
        let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: {foo: :bar}) }

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

    example_group "alias methods" do
      include ConvenientService::RSpec::Matchers::HaveAliasMethod

      subject { data }

      it { is_expected.to have_alias_method(:__value__, :value) }
      it { is_expected.to have_alias_method(:__result__, :result) }
      it { is_expected.to have_alias_method(:__empty__?, :empty?) }
      it { is_expected.to have_alias_method(:__has_attribute__?, :has_attribute?) }
      it { is_expected.to have_alias_method(:__keys__, :keys) }
    end

    describe "#empty?" do
      specify do
        expect { data.empty? }
          .to delegate_to(data, :__value__)
          .without_arguments
      end

      context "when `data` has NO keys" do
        let(:value) { {} }

        it "returns `true`" do
          expect(data.empty?).to be(true)
        end
      end

      context "when `data` has any key" do
        let(:value) { {foo: :bar} }

        it "returns `false`" do
          expect(data.empty?).to be(false)
        end
      end
    end

    describe "#__empty__?" do
      specify do
        expect { data.__empty__? }
          .to delegate_to(data, :__value__)
          .without_arguments
      end

      context "when `data` has NO keys" do
        let(:value) { {} }

        it "returns `true`" do
          expect(data.__empty__?).to be(true)
        end
      end

      context "when `data` has any key" do
        let(:value) { {foo: :bar} }

        it "returns `false`" do
          expect(data.__empty__?).to be(false)
        end
      end
    end

    describe "#has_attribute?" do
      specify do
        expect { data.has_attribute?(:foo) }
          .to delegate_to(data, :__value__)
          .without_arguments
      end

      context "when `data` has NO attribute by key" do
        let(:value) { {} }

        it "returns `false`" do
          expect(data.has_attribute?(:foo)).to be(false)
        end

        context "when key is string" do
          it "converts that key to symbol" do
            expect(data.has_attribute?("foo")).to be(false)
          end
        end
      end

      context "when `data` has attribute by key" do
        let(:value) { {foo: :bar} }

        it "returns `true`" do
          expect(data.has_attribute?(:foo)).to be(true)
        end

        context "when key is string" do
          it "converts that key to symbol" do
            expect(data.has_attribute?("foo")).to be(true)
          end
        end
      end
    end

    describe "#__has_attribute__?" do
      specify do
        expect { data.__has_attribute__?(:foo) }
          .to delegate_to(data, :__value__)
          .without_arguments
      end

      context "when `data` has NO attribute by key" do
        let(:value) { {} }

        it "returns `false`" do
          expect(data.__has_attribute__?(:foo)).to be(false)
        end

        context "when key is string" do
          it "converts that key to symbol" do
            expect(data.__has_attribute__?("foo")).to be(false)
          end
        end
      end

      context "when `data` has attribute by key" do
        let(:value) { {foo: :bar} }

        it "returns `true`" do
          expect(data.__has_attribute__?(:foo)).to be(true)
        end

        context "when key is string" do
          it "converts that key to symbol" do
            expect(data.__has_attribute__?("foo")).to be(true)
          end
        end
      end
    end

    describe "#attributes" do
      it "returns value" do
        expect(data.attributes).to eq(value)
      end

      specify do
        expect { data.attributes }.to cache_its_value
      end
    end

    describe "#__attributes__" do
      it "returns value" do
        expect(data.__attributes__).to eq(value)
      end

      specify do
        expect { data.__attributes__ }.to cache_its_value
      end
    end

    describe "#keys" do
      specify do
        expect { data.keys }
          .to delegate_to(data.__value__, :keys)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#__keys__" do
      specify do
        expect { data.__keys__ }
          .to delegate_to(data.__value__, :keys)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#struct" do
      specify do
        expect { data.struct }.to cache_its_value
      end

      it "returns `Struct` instance" do
        expect(data.struct).to be_a(Struct)
      end

      example_group "`Struct` instance" do
        let(:value) { {foo: :foo, bar: :bar} }

        it "has defined methods for each data attribute" do
          expect(value.keys.all? { |key| data.struct.respond_to?(key) }).to be(true)
        end

        example_group "method" do
          it "returns corresponding value" do
            expect([data.struct.foo, data.struct.bar]).to eq(data.to_h.values)
          end
        end

        context "when data has NOT attributes" do
          let(:value) { {foo: :foo, bar: :bar} }

          it "does NOT raise" do
            expect { data.struct }.not_to raise_error
          end
        end
      end
    end

    describe "#__struct__" do
      specify do
        expect { data.__struct__ }.to cache_its_value
      end

      it "returns `Struct` instance" do
        expect(data.__struct__).to be_a(Struct)
      end

      example_group "`Struct` instance" do
        let(:value) { {foo: :foo, bar: :bar} }

        it "has defined methods for each data attribute" do
          expect(value.keys.all? { |key| data.__struct__.respond_to?(key) }).to be(true)
        end

        example_group "method" do
          it "returns corresponding value" do
            expect([data.__struct__.foo, data.__struct__.bar]).to eq(data.to_h.values)
          end
        end

        context "when data has NOT attributes" do
          let(:value) { {foo: :foo, bar: :bar} }

          it "does NOT raise" do
            expect { data.__struct__ }.not_to raise_error
          end
        end
      end
    end

    describe "#[]" do
      specify do
        expect { data[:foo] }
          .to delegate_to(data, :__value__)
          .without_arguments
      end

      it "returns `data` attribute by string key" do
        expect(data["foo"]).to eq(:bar)
      end

      it "returns `data` attribute by symbol key" do
        expect(data[:foo]).to eq(:bar)
      end

      context "when NO `data` attribute exist for passed key" do
        let(:exception_message) do
          <<~TEXT
            Data attribute `:abc` does NOT exist. Make sure the corresponding result returns it.
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Exceptions::NotExistingAttribute`" do
          expect { data[:abc] }
            .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Exceptions::NotExistingAttribute)
            .with_message(exception_message)
        end

        specify do
          expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Exceptions::NotExistingAttribute) { data[:abc] } }
            .to delegate_to(ConvenientService, :raise)
        end
      end
    end

    describe "#fetch" do
      specify do
        expect { data.fetch(:foo) }
          .to delegate_to(data, :__value__)
          .without_arguments
      end

      context "when `block` is NOT passed" do
        it "returns `data` attribute by string key" do
          expect(data.fetch("foo")).to eq(:bar)
        end

        it "returns `data` attribute by symbol key" do
          expect(data.fetch(:foo)).to eq(:bar)
        end

        context "when NO `data` attribute exist for passed key" do
          let(:exception_message) do
            <<~TEXT
              Data attribute `:abc` does NOT exist. Make sure the corresponding result returns it.
            TEXT
          end

          it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Exceptions::NotExistingAttribute`" do
            expect { data.fetch(:abc) }
              .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Exceptions::NotExistingAttribute)
              .with_message(exception_message)
          end

          specify do
            expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Exceptions::NotExistingAttribute) { data.fetch(:abc) } }
              .to delegate_to(ConvenientService, :raise)
          end
        end
      end

      context "when `block` is passed" do
        let(:block) { proc { |key| "missing key: :#{key}" } }

        it "returns `data` attribute by string key" do
          expect(data.fetch("foo", &block)).to eq(:bar)
        end

        it "returns `data` attribute by symbol key" do
          expect(data.fetch(:foo, &block)).to eq(:bar)
        end

        context "when NO `data` attribute exist for passed key" do
          it "returns `block` value" do
            expect(data.fetch(:foo, &block)).to eq("missing key: :foo")
          end

          it "passes `key` as `block` arg" do
            expect { data.fetch(:abc, &block) }
              .to delegate_to(block, :call)
              .with_arguments(key)
              .and_return_its_value
          end
        end
      end
    end

    describe "#__fetch__" do
      specify do
        expect { data.__fetch__(:foo) }
          .to delegate_to(data, :__value__)
          .without_arguments
      end

      context "when `block` is NOT passed" do
        it "returns `data` attribute by string key" do
          expect(data.__fetch__("foo")).to eq(:bar)
        end

        it "returns `data` attribute by symbol key" do
          expect(data.__fetch__(:foo)).to eq(:bar)
        end

        context "when NO `data` attribute exist for passed key" do
          let(:exception_message) do
            <<~TEXT
              Data attribute `:abc` does NOT exist. Make sure the corresponding result returns it.
            TEXT
          end

          it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Exceptions::NotExistingAttribute`" do
            expect { data.__fetch__(:abc) }
              .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Exceptions::NotExistingAttribute)
              .with_message(exception_message)
          end

          specify do
            expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Exceptions::NotExistingAttribute) { data.__fetch__(:abc) } }
              .to delegate_to(ConvenientService, :raise)
          end
        end
      end

      context "when `block` is passed" do
        let(:block) { proc { |key| "missing key: :#{key}" } }

        it "returns `data` attribute by string key" do
          expect(data.__fetch__("foo", &block)).to eq(:bar)
        end

        it "returns `data` attribute by symbol key" do
          expect(data.__fetch__(:foo, &block)).to eq(:bar)
        end

        context "when NO `data` attribute exist for passed key" do
          it "returns `block` value" do
            expect(data.__fetch__(:foo, &block)).to eq("missing key: :foo")
          end

          it "passes `key` as `block` arg" do
            expect { data.__fetch__(:abc, &block) }
              .to delegate_to(block, :call)
              .with_arguments(key)
              .and_return_its_value
          end
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
          let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: {foo: :baz}, result: result) }

          specify do
            expect { data == other }.to delegate_to(data.value, :==).with_arguments(other.value)
          end

          it "returns `false`" do
            expect(data == other).to be(false)
          end

          context "when value is described by RSpec expectations matcher" do
            context "when value is described by RSpec expectations matcher in `data`" do
              let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: respond_to(:keys), result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }

              it "does NOT respect that RSpec expectations matcher" do
                expect(data == other).to be(false)
              end
            end

            context "when value is described by RSpec expectations matcher in `other`" do
              let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: respond_to(:keys), result: result) }

              it "does NOT respect that RSpec expectations matcher" do
                expect(data == other).to be(false)
              end
            end
          end

          context "when value is described by RSpec mocks arguments matcher" do
            context "when value is described by RSpec mocks arguments matcher in `data`" do
              let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: instance_of(Hash), result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }

              it "does NOT respect that RSpec mocks arguments matcher" do
                expect(data == other).to be(false)
              end
            end

            context "when value is described by RSpec mocks arguments matcher in `other`" do
              let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: instance_of(Hash), result: result) }

              it "does NOT respect that RSpec mocks arguments matcher" do
                expect(data == other).to be(false)
              end
            end
          end
        end

        context "when `other` has different `result.class`" do
          let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: Object.new) }

          specify do
            expect { data == other }.to delegate_to(data.result.class, :==).with_arguments(other.result.class)
          end

          it "returns `false`" do
            expect(data == other).to be(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }

          it "returns `true`" do
            expect(data == other).to be(true)
          end

          specify do
            expect { data == other }
              .to delegate_to(data, :__result__)
              .without_arguments
          end

          specify do
            expect { data == other }
              .to delegate_to(other, :__result__)
              .without_arguments
          end

          specify do
            expect { data == other }
              .to delegate_to(data, :__value__)
              .without_arguments
          end

          specify do
            expect { data == other }
              .to delegate_to(other, :__value__)
              .without_arguments
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
          context "when `other` value is hash" do
            let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: {foo: :baz}, result: result) }

            specify do
              expect { data === other }.to delegate_to(ConvenientService::Utils::Hash, :triple_equality_compare).with_arguments(data.value, other.value)
            end

            it "returns `false`" do
              expect(data === other).to be(false)
            end

            specify do
              expect { data === other }
                .to delegate_to(data, :__result__)
                .without_arguments
            end

            specify do
              expect { data === other }
                .to delegate_to(other, :__result__)
                .without_arguments
            end

            specify do
              expect { data === other }
                .to delegate_to(data, :__value__)
                .without_arguments
            end

            specify do
              expect { data === other }
                .to delegate_to(other, :__value__)
                .without_arguments
            end
          end

          context "when value is described by RSpec expectations matcher" do
            context "when value is described by RSpec expectations matcher in `data`" do
              let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: {foo: match(/bar/)}, result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }

              it "respects that RSpec expectations matcher" do
                expect(data === other).to be(true)
              end
            end

            context "when value is described by RSpec expectations matcher in `other`" do
              let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: {foo: match(/bar/)}, result: result) }

              it "does NOT respect that RSpec expectations matcher" do
                expect(data === other).to be(false)
              end
            end
          end

          context "when value is described by RSpec mocks arguments matcher" do
            context "when value is described by RSpec mocks arguments matcher in `code`" do
              let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: {foo: instance_of(Symbol)}, result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }

              it "respects that RSpec mocks arguments matcher" do
                expect(data === other).to be(true)
              end
            end

            context "when value is described by RSpec mocks arguments matcher in `other`" do
              let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: {foo: instance_of(Symbol)}, result: result) }

              it "does NOT respect that RSpec mocks arguments matcher" do
                expect(data === other).to be(false)
              end
            end
          end

          context "when `other` value is NOT hash" do
            let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: [], result: result) }

            specify do
              expect { data === other }.to delegate_to(data.value, :===).with_arguments(other.value)
            end

            it "returns `false`" do
              expect(data === other).to be(false)
            end

            context "when value is described by RSpec expectations matcher" do
              context "when value is described by RSpec expectations matcher in `data`" do
                let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: respond_to(:keys), result: result) }
                let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }

                it "respects that RSpec expectations matcher" do
                  expect(data === other).to be(true)
                end
              end

              context "when value is described by RSpec expectations matcher in `other`" do
                let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }
                let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: respond_to(:keys), result: result) }

                it "does NOT respect that RSpec expectations matcher" do
                  expect(data === other).to be(false)
                end
              end
            end

            context "when value is described by RSpec mocks arguments matcher" do
              context "when value is described by RSpec mocks arguments matcher in `data`" do
                let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: hash_including(:foo), result: result) }
                let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }

                it "respects that RSpec mocks arguments matcher" do
                  expect(data === other).to be(true)
                end
              end

              context "when value is described by RSpec mocks arguments matcher in `other`" do
                let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }
                let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: hash_including(:foo), result: result) }

                it "does NOT respect that RSpec mocks arguments matcher" do
                  expect(data === other).to be(false)
                end
              end
            end

            context "when value is described by RSpec mocks arguments matcher with nested RSpec expectations matcher" do
              context "when value is described by RSpec mocks arguments matcher with nested RSpec expectations matcher in `data`" do
                let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: hash_including(foo: match(/bar/)), result: result) }
                let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }

                it "respects that RSpec expectations matcher" do
                  expect(data === other).to be(true)
                end
              end

              context "when value is described by RSpec mocks arguments matcher with nested RSpec expectations matcher in `other`" do
                let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }
                let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: hash_including(foo: match(/bar/)), result: result) }

                it "does NOT respect that RSpec expectations matcher" do
                  expect(data === other).to be(false)
                end
              end
            end

            context "when value is described by RSpec mocks arguments matcher with nested RSpec mocks arguments matcher" do
              context "when value is described by RSpec mocks arguments matcher with nested RSpec mocks arguments matcher in `data`" do
                let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: hash_including(foo: instance_of(Symbol)), result: result) }
                let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }

                it "respects that RSpec mocks arguments matcher" do
                  expect(data === other).to be(true)
                end
              end

              context "when value is described by RSpec mocks arguments matcher with nested RSpec mocks arguments matcher in `other`" do
                let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }
                let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: hash_including(foo: instance_of(Symbol)), result: result) }

                it "does NOT respect that RSpec mocks arguments matcher" do
                  expect(data === other).to be(false)
                end
              end
            end
          end
        end

        context "when `other` has different `result.class`" do
          let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: Object.new) }

          specify do
            expect { data === other }.to delegate_to(data.result.class, :==).with_arguments(other.result.class)
          end

          it "returns `false`" do
            expect(data === other).to be(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }

          it "returns `true`" do
            expect(data === other).to be(true)
          end

          specify do
            expect { data === other }
              .to delegate_to(data, :__result__)
              .without_arguments
          end

          specify do
            expect { data === other }
              .to delegate_to(other, :__result__)
              .without_arguments
          end

          specify do
            expect { data === other }
              .to delegate_to(data, :__value__)
              .without_arguments
          end

          specify do
            expect { data === other }
              .to delegate_to(other, :__value__)
              .without_arguments
          end
        end
      end
    end

    example_group "conversions" do
      let(:arguments) { ConvenientService::Support::Arguments.new(**kwargs) }
      let(:kwargs) { {value: value, result: result} }

      describe "#to_kwargs" do
        specify do
          allow(data).to receive(:to_arguments).and_return(arguments)

          expect { data.to_kwargs }
            .to delegate_to(data.to_arguments, :kwargs)
            .without_arguments
            .and_return_its_value
        end

        specify do
          expect { data.to_kwargs }.to cache_its_value
        end
      end

      describe "#to_arguments" do
        specify do
          expect { data.to_arguments }
            .to delegate_to(data, :__value__)
            .without_arguments
        end

        specify do
          expect { data.to_arguments }
            .to delegate_to(data, :__result__)
            .without_arguments
        end

        it "returns arguments representation of data" do
          expect(data.to_arguments).to eq(arguments)
        end

        specify do
          expect { data.to_arguments }.to cache_its_value
        end
      end

      describe "#to_h" do
        specify do
          expect { data.to_h }
            .to delegate_to(data, :__value__)
            .without_arguments
        end

        it "returns hash representation of `data`" do
          expect(data.to_h).to eq({foo: :bar})
        end

        specify do
          expect { data.to_h }.to cache_its_value
        end
      end

      describe "#to_s" do
        it "returns string representation of `data`" do
          expect { data.to_s }
            .to delegate_to(data.__value__, :to_s)
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
