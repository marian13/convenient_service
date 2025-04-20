# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message::Concern::InstanceMethods, type: :standard do
  include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:message) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: value, result: result) }
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
        let(:message) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: "foo") }

        it "defaults to `nil`" do
          expect(message.result).to be_nil
        end
      end
    end
  end

  example_group "instance methods" do
    example_group "attributes" do
      include ConvenientService::RSpec::PrimitiveMatchers::HaveAttrReader

      subject { message }

      it { is_expected.to have_attr_reader(:value) }
      it { is_expected.to have_attr_reader(:result) }
    end

    describe "#empty?" do
      ##
      # NOTE: `value` is unfrozen in order to allow stubs on it. Otherwise an excepion like the following is raised:
      #
      #   ArgumentError:
      #     Cannot proxy frozen objects, rspec-mocks relies on proxies for method stubbing and expectations.
      #
      let(:value) { +"foo" }

      specify do
        expect { message.empty? }
          .to delegate_to(message.value, :empty?)
          .without_arguments
          .and_return_its_value
      end
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
          let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: "bar", result: result) }

          specify do
            expect { message == other }.to delegate_to(message.value, :==).with_arguments(other.value)
          end

          it "returns `false`" do
            expect(message == other).to eq(false)
          end

          context "when value is described by RSpec expectations matcher" do
            context "when value is described by RSpec expectations matcher in `message`" do
              let(:message) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: match(/foo/), result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: value, result: result) }

              it "does NOT respect that RSpec expectations matcher" do
                expect(message == other).to eq(false)
              end
            end

            context "when value is described by RSpec expectations matcher in `other`" do
              let(:message) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: value, result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: match(/foo/), result: result) }

              it "does NOT respect that RSpec expectations matcher" do
                expect(message == other).to eq(false)
              end
            end
          end

          context "when value is described by RSpec mocks arguments matcher" do
            context "when value is described by RSpec mocks arguments matcher in `message`" do
              let(:message) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: instance_of(String), result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: value, result: result) }

              it "does NOT respect that RSpec mocks arguments matcher" do
                expect(message == other).to eq(false)
              end
            end

            context "when value is described by RSpec mocks arguments matcher in `other`" do
              let(:message) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: value, result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: instance_of(String), result: result) }

              it "does NOT respect that RSpec mocks arguments matcher" do
                expect(message == other).to eq(false)
              end
            end
          end
        end

        context "when `other` has different `result.class`" do
          let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: value, result: Object.new) }

          specify do
            expect { message == other }.to delegate_to(message.result.class, :==).with_arguments(other.result.class)
          end

          it "returns `false`" do
            expect(message == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: value, result: result) }

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
          ##
          # NOTE: Unfreezes `value` in order to have an ability to use `delegate_to` on it.
          #
          let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: +"bar", result: result) }

          specify do
            expect { message === other }.to delegate_to(message.value, :===).with_arguments(other.value)
          end

          it "returns `false`" do
            expect(message === other).to eq(false)
          end

          context "when value is described by RSpec expectations matcher" do
            context "when value is described by RSpec expectations matcher in `message`" do
              let(:message) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: match(/foo/), result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: value, result: result) }

              it "respects that RSpec expectations matcher" do
                expect(message === other).to eq(true)
              end
            end

            context "when value is described by RSpec expectations matcher in `other`" do
              let(:message) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: value, result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: match(/foo/), result: result) }

              it "does NOT respect that RSpec expectations matcher" do
                expect(message === other).to eq(false)
              end
            end
          end

          context "when value is described by RSpec mocks arguments matcher" do
            context "when value is described by RSpec mocks arguments matcher in `message`" do
              let(:message) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: instance_of(String), result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: value, result: result) }

              it "respects that RSpec mocks arguments matcher" do
                expect(message === other).to eq(true)
              end
            end

            context "when value is described by RSpec mocks arguments matcher in `other`" do
              let(:message) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: value, result: result) }
              let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: instance_of(String), result: result) }

              it "does NOT respect that RSpec mocks arguments matcher" do
                expect(message === other).to eq(false)
              end
            end
          end
        end

        context "when `other` has different `result.class`" do
          let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: value, result: Object.new) }

          specify do
            expect { message === other }.to delegate_to(message.result.class, :==).with_arguments(other.result.class)
          end

          it "returns `false`" do
            expect(message === other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: value, result: result) }

          it "returns `true`" do
            expect(message === other).to eq(true)
          end
        end
      end
    end

    example_group "conversions" do
      let(:arguments) { ConvenientService::Support::Arguments.new(**kwargs) }
      let(:kwargs) { {value: value, result: result} }

      describe "#to_kwargs" do
        specify do
          allow(message).to receive(:to_arguments).and_return(arguments)

          expect { message.to_kwargs }
            .to delegate_to(message.to_arguments, :kwargs)
            .without_arguments
            .and_return_its_value
        end

        specify do
          expect { message.to_kwargs }.to cache_its_value
        end
      end

      describe "#to_arguments" do
        it "returns arguments representation of message" do
          expect(message.to_arguments).to eq(arguments)
        end

        specify do
          expect { message.to_arguments }.to cache_its_value
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
