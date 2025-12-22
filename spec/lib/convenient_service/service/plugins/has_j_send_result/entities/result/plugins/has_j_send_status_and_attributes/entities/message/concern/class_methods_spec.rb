# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message::Concern::ClassMethods, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".message_class?" do
      let(:klass) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message }

      context "when `message` is NOT class" do
        let(:message_class) { 42 }

        it "returns `false`" do
          expect(klass.message_class?(message_class)).to be(false)
        end
      end

      context "when `message` is class" do
        context "when `message` is NOT message class" do
          let(:message_class) { Class.new }

          it "returns `false`" do
            expect(klass.message_class?(message_class)).to be(false)
          end

          context "when `message` is entity class" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Standard::Config

                def result
                  success
                end
              end
            end

            it "returns `false`" do
              expect(klass.message_class?(service_class)).to be(false)
            end
          end
        end

        context "when `message` is message class" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success
              end
            end
          end

          let(:message_class) { service_class.new.result.unsafe_message.class }

          it "returns `true`" do
            expect(klass.message_class?(message_class)).to be(true)
          end
        end
      end
    end

    describe ".message?" do
      let(:klass) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message }

      let(:service_class) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success
          end
        end
      end

      let(:message_class) { service_class.result_class.message_class }
      let(:data_instance) { service_class.result.unsafe_message }

      specify do
        expect { klass.message?(data_instance) }
          .to delegate_to(klass, :message_class?)
          .with_arguments(message_class)
          .and_return_its_value
      end
    end

    describe ".cast" do
      let(:casted) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.cast(other) }

      context "when `other` is NOT castable" do
        let(:other) { nil }

        it "returns `nil`" do
          expect(casted).to be_nil
        end
      end

      context "when `other` is symbol" do
        let(:other) { :foo }
        let(:message) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: other.to_s) }

        it "returns that symbol casted to message" do
          expect(casted).to eq(message)
        end
      end

      context "when `other` is string" do
        let(:other) { "foo" }
        let(:message) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: other) }

        it "returns that string casted to message" do
          expect(casted).to eq(message)
        end
      end

      context "when `other` is message" do
        let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: "foo") }
        let(:message) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: other.value) }

        it "returns copy of `other`" do
          expect(casted).to eq(message)
        end
      end
    end

    describe ".===" do
      let(:message_class) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message }

      let(:other) { 42 }

      specify do
        expect { message_class === other }
          .to delegate_to(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message, :message?)
          .with_arguments(other)
      end

      it "returns `false`" do
        expect(message_class === other).to be(false)
      end

      context "when `other` is message instance in terms of `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.message?`" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success
            end
          end
        end

        let(:other) { service.result.unsafe_message }

        specify do
          expect { message_class === other }
            .to delegate_to(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message, :message?)
            .with_arguments(other)
        end

        it "returns `true`" do
          expect(message_class === other).to be(true)
        end
      end

      context "when `other` is `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message` instance" do
        let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.cast("foo") }

        it "returns `true`" do
          expect(message_class === other).to be(true)
        end
      end

      context "when `other` is `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message` descendant instance" do
        let(:descendant_class) { Class.new(message_class) }

        let(:other) { descendant_class.cast("foo") }

        it "returns `true`" do
          expect(message_class === other).to be(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
