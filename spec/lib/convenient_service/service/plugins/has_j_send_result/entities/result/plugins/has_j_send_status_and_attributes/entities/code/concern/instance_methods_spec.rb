# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code::Concern::InstanceMethods do
  include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue

  let(:code) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: value, result: result) }
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
        let(:code) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: :foo) }

        it "defaults to `nil`" do
          expect(code.result).to be_nil
        end
      end
    end
  end

  example_group "instance methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    example_group "attributes" do
      include ConvenientService::RSpec::PrimitiveMatchers::HaveAttrReader

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
          let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: :bar, result: result) }

          ##
          # NOTE: This spec is skipped since it is NOT possible to stub immediate values like symbols.
          #
          # specify do
          #   expect { code == other }.to delegate_to(code.value, :==).with_arguments(other.value)
          # end

          it "returns `false`" do
            expect(code == other).to eq(false)
          end

          context "when value is described by RSpec expectations matcher" do
            context "when value is described by RSpec expectations matcher in `code`" do
              let(:code) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: match(/foo/), result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: value, result: result) }

              it "does NOT respect that RSpec expectations matcher" do
                expect(code == other).to eq(false)
              end
            end

            context "when value is described by RSpec expectations matcher in `other`" do
              let(:code) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: value, result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: match(/foo/), result: result) }

              it "does NOT respect that RSpec expectations matcher" do
                expect(code == other).to eq(false)
              end
            end
          end

          context "when value is described by RSpec mocks arguments matcher" do
            context "when value is described by RSpec mocks arguments matcher in `code`" do
              let(:code) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: instance_of(Symbol), result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: value, result: result) }

              it "does NOT respect that RSpec mocks arguments matcher" do
                expect(code == other).to eq(false)
              end
            end

            context "when value is described by RSpec mocks arguments matcher in `other`" do
              let(:code) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: value, result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: instance_of(Symbol), result: result) }

              it "does NOT respect that RSpec mocks arguments matcher" do
                expect(code == other).to eq(false)
              end
            end
          end
        end

        context "when `other` has different `result.class`" do
          let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: value, result: Object.new) }

          ##
          # NOTE: This spec is skipped since it is NOT possible to stub immediate values like symbols.
          #
          # specify do
          #   expect { code == other }.to delegate_to(code.result.class, :==).with_arguments(other.result.class)
          # end

          it "returns `false`" do
            expect(code == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: value, result: result) }

          it "returns `true`" do
            expect(code == other).to eq(true)
          end
        end
      end

      describe "#===" do
        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(code === other).to be_nil
          end
        end

        context "when `other` has different `value`" do
          let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: :bar, result: result) }

          ##
          # NOTE: This spec is skipped since it is NOT possible to stub immediate values like symbols.
          #
          # specify do
          #   expect { code === other }.to delegate_to(code.value, :===).with_arguments(other.value)
          # end

          it "returns `false`" do
            expect(code === other).to eq(false)
          end

          context "when value is described by RSpec expectations matcher" do
            context "when value is described by RSpec expectations matcher in `code`" do
              let(:code) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: match(/foo/), result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: value, result: result) }

              it "respects that RSpec expectations matcher" do
                expect(code === other).to eq(true)
              end
            end

            context "when value is described by RSpec expectations matcher in `other`" do
              let(:code) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: value, result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: match(/foo/), result: result) }

              it "does NOT respect that RSpec expectations matcher" do
                expect(code === other).to eq(false)
              end
            end
          end

          context "when value is described by RSpec mocks arguments matcher" do
            context "when value is described by RSpec mocks arguments matcher in `code`" do
              let(:code) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: instance_of(Symbol), result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: value, result: result) }

              it "respects that RSpec mocks arguments matcher" do
                expect(code === other).to eq(true)
              end
            end

            context "when value is described by RSpec mocks arguments matcher in `other`" do
              let(:code) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: value, result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: instance_of(Symbol), result: result) }

              it "does NOT respect that RSpec mocks arguments matcher" do
                expect(code === other).to eq(false)
              end
            end
          end
        end

        context "when `other` has different `result.class`" do
          let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: value, result: Object.new) }

          ##
          # NOTE: This spec is skipped since it is NOT possible to stub immediate values like symbols.
          #
          # specify do
          #   expect { code === other }.to delegate_to(code.result.class).with_arguments(other.result.class, :===)
          # end

          it "returns `false`" do
            expect(code === other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.new(value: value, result: result) }

          it "returns `true`" do
            expect(code === other).to eq(true)
          end
        end
      end
    end

    example_group "conversions" do
      let(:arguments) { ConvenientService::Support::Arguments.new(**kwargs) }
      let(:kwargs) { {value: value, result: result} }

      describe "#to_kwargs" do
        specify do
          allow(code).to receive(:to_arguments).and_return(arguments)

          expect { code.to_kwargs }
            .to delegate_to(code.to_arguments, :kwargs)
            .without_arguments
            .and_return_its_value
        end

        specify do
          expect { code.to_kwargs }.to cache_its_value
        end
      end

      describe "#to_arguments" do
        it "returns arguments representation of code" do
          expect(code.to_arguments).to eq(arguments)
        end

        specify do
          expect { code.to_arguments }.to cache_its_value
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
