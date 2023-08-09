# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data::Concern::InstanceMethods do
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
        let(:exception_message) do
          <<~TEXT
            Data attribute `abc` does NOT exist. Make sure the corresponding result returns it.
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Exceptions::NotExistingAttribute`" do
          expect { data[:abc] }
            .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Exceptions::NotExistingAttribute)
            .with_message(exception_message)
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
            expect(data == other).to eq(false)
          end

          context "when value is described by RSpec expectations matcher" do
            context "when value is described by RSpec expectations matcher in `data`" do
              let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: respond_to(:keys), result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }

              it "does NOT respect that RSpec expectations matcher" do
                expect(data == other).to eq(false)
              end
            end

            context "when value is described by RSpec expectations matcher in `other`" do
              let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: respond_to(:keys), result: result) }

              it "does NOT respect that RSpec expectations matcher" do
                expect(data == other).to eq(false)
              end
            end
          end

          context "when value is described by RSpec mocks arguments matcher" do
            context "when value is described by RSpec mocks arguments matcher in `data`" do
              let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: instance_of(Hash), result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }

              it "does NOT respect that RSpec mocks arguments matcher" do
                expect(data == other).to eq(false)
              end
            end

            context "when value is described by RSpec mocks arguments matcher in `other`" do
              let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: instance_of(Hash), result: result) }

              it "does NOT respect that RSpec mocks arguments matcher" do
                expect(data == other).to eq(false)
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
            expect(data == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }

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
          context "when `other` value is hash" do
            let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: {foo: :baz}, result: result) }

            specify do
              expect { data === other }.to delegate_to(ConvenientService::Utils::Hash, :triple_equality_compare).with_arguments(data.value, other.value)
            end

            it "returns `false`" do
              expect(data === other).to eq(false)
            end
          end

          context "when value is described by RSpec expectations matcher" do
            context "when value is described by RSpec expectations matcher in `data`" do
              let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: {foo: match(/bar/)}, result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }

              it "respects that RSpec expectations matcher" do
                expect(data === other).to eq(true)
              end
            end

            context "when value is described by RSpec expectations matcher in `other`" do
              let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: {foo: match(/bar/)}, result: result) }

              it "does NOT respect that RSpec expectations matcher" do
                expect(data === other).to eq(false)
              end
            end
          end

          context "when value is described by RSpec mocks arguments matcher" do
            context "when value is described by RSpec mocks arguments matcher in `code`" do
              let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: {foo: instance_of(Symbol)}, result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }

              it "respects that RSpec mocks arguments matcher" do
                expect(data === other).to eq(true)
              end
            end

            context "when value is described by RSpec mocks arguments matcher in `other`" do
              let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: {foo: instance_of(Symbol)}, result: result) }

              it "does NOT respect that RSpec mocks arguments matcher" do
                expect(data === other).to eq(false)
              end
            end
          end

          context "when `other` value is NOT hash" do
            let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: [], result: result) }

            specify do
              expect { data === other }.to delegate_to(data.value, :===).with_arguments(other.value)
            end

            it "returns `false`" do
              expect(data === other).to eq(false)
            end

            context "when value is described by RSpec expectations matcher" do
              context "when value is described by RSpec expectations matcher in `data`" do
                let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: respond_to(:keys), result: result) }
                let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }

                it "respects that RSpec expectations matcher" do
                  expect(data === other).to eq(true)
                end
              end

              context "when value is described by RSpec expectations matcher in `other`" do
                let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }
                let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: respond_to(:keys), result: result) }

                it "does NOT respect that RSpec expectations matcher" do
                  expect(data === other).to eq(false)
                end
              end
            end

            context "when value is described by RSpec mocks arguments matcher" do
              context "when value is described by RSpec mocks arguments matcher in `data`" do
                let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: hash_including(:foo), result: result) }
                let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }

                it "respects that RSpec mocks arguments matcher" do
                  expect(data === other).to eq(true)
                end
              end

              context "when value is described by RSpec mocks arguments matcher in `other`" do
                let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }
                let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: hash_including(:foo), result: result) }

                it "does NOT respect that RSpec mocks arguments matcher" do
                  expect(data === other).to eq(false)
                end
              end
            end

            context "when value is described by RSpec mocks arguments matcher with nested RSpec expectations matcher" do
              context "when value is described by RSpec mocks arguments matcher with nested RSpec expectations matcher in `data`" do
                let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: hash_including(foo: match(/bar/)), result: result) }
                let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }

                it "respects that RSpec expectations matcher" do
                  expect(data === other).to eq(true)
                end
              end

              context "when value is described by RSpec mocks arguments matcher with nested RSpec expectations matcher in `other`" do
                let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }
                let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: hash_including(foo: match(/bar/)), result: result) }

                it "does NOT respect that RSpec expectations matcher" do
                  expect(data === other).to eq(false)
                end
              end
            end

            context "when value is described by RSpec mocks arguments matcher with nested RSpec mocks arguments matcher" do
              context "when value is described by RSpec mocks arguments matcher with nested RSpec mocks arguments matcher in `data`" do
                let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: hash_including(foo: instance_of(Symbol)), result: result) }
                let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }

                it "respects that RSpec mocks arguments matcher" do
                  expect(data === other).to eq(true)
                end
              end

              context "when value is described by RSpec mocks arguments matcher with nested RSpec mocks arguments matcher in `other`" do
                let(:data) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }
                let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: hash_including(foo: instance_of(Symbol)), result: result) }

                it "does NOT respect that RSpec mocks arguments matcher" do
                  expect(data === other).to eq(false)
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
            expect(data === other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.new(value: value, result: result) }

          it "returns `true`" do
            expect(data === other).to eq(true)
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
        it "returns arguments representation of data" do
          expect(data.to_arguments).to eq(arguments)
        end

        specify do
          expect { data.to_arguments }.to cache_its_value
        end
      end

      describe "#to_h" do
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
