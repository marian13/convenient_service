# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeCalled::Concern, type: :standard do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { result_class }

      let(:result_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to include_module(described_class::InstanceMethods) }
    end
  end

  example_group "instance methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo
    include ConvenientService::RSpec::Helpers::IgnoringException

    describe "#call" do
      let(:result) { service.result }

      context "when result has `success` status" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success(foo: :bar)
            end

            def self.name
              "ImportantService"
            end
          end
        end

        it "returns result data as hash" do
          expect(result.call).to eq({foo: :bar})
        end

        context "when result has NO data" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success
              end

              def self.name
                "ImportantService"
              end
            end
          end

          it "returns empty hash" do
            expect(result.call).to eq({})
          end
        end
      end

      context "when result has `failure` status" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              failure("message from failure")
            end

            def self.name
              "ImportantService"
            end
          end
        end

        it "returns `nil`" do
          expect(result.call).to be_nil
        end
      end

      context "when result has `error` status" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              error("message from error")
            end

            def self.name
              "ImportantService"
            end
          end
        end

        let(:exception_message) do
          <<~TEXT
            An `error` result of service `#{ConvenientService::Utils::Class.display_name(result.service.class)}` is called.

            Only the `success` and `failure` results are expected to be called.

            If this `error` result is expected:
            1. Consider to use the `result` method instead of `call` (ensure the `:fault_tolerance` config option is enabled) - preferred.
            2. Consider to use `begin/rescue ConvenientService::Result::Exceptions::ErrorResultIsCalled`.

            If this `error` result is NOT expected, update the service logic.

            Original `error` result message:
              #{result.unsafe_message}
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeCalled::Exceptions::ErrorResultIsCalled`" do
          expect { result.call }
            .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeCalled::Exceptions::ErrorResultIsCalled)
            .with_message(exception_message)
        end

        specify do
          expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeCalled::Exceptions::ErrorResultIsCalled) { result.call } }
            .to delegate_to(ConvenientService, :raise)
        end

        example_group "fault tolerance" do
          let(:exception) do
            service.result
          rescue => an_exception
            an_exception
          end

          context "when service raises exception" do
            context "when fault tolerance is NOT enabled" do
              let(:service) do
                Class.new do
                  include ConvenientService::Standard::Config.without(:fault_tolerance)

                  def result
                    raise ZeroDivisionError, "exception message", caller.take(5).map { |line| line.prepend("/end_user") }
                  end

                  def self.name
                    "ImportantService"
                  end
                end
              end

              it "raises that original service exception" do
                expect { result.call }
                  .to raise_error(exception.class)
                  .with_message(exception.message)
              end

              specify do
                expect { ignoring_exception(exception.class) { result.call } }
                  .not_to delegate_to(ConvenientService, :raise)
              end
            end

            context "when fault tolerance is enabled" do
              let(:service) do
                Class.new do
                  include ConvenientService::Standard::Config.with(:fault_tolerance)

                  def result
                    raise ZeroDivisionError, "exception message", caller.take(5).map { |line| line.prepend("/end_user") }
                  end

                  def self.name
                    "ImportantService"
                  end
                end
              end

              it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeCalled::Exceptions::ErrorResultIsCalled` with explanation" do
                expect { result.call }
                  .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeCalled::Exceptions::ErrorResultIsCalled)
                  .with_message(/An `error` result of service `#{Regexp.escape(ConvenientService::Utils::Class.display_name(service))}` is called./)
              end

              it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeCalled::Exceptions::ErrorResultIsCalled` with original message" do
                expect { result.call }
                  .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeCalled::Exceptions::ErrorResultIsCalled)
                  .with_message(/ZeroDivisionError/)
              end

              specify do
                expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeCalled::Exceptions::ErrorResultIsCalled) { result.call } }
                  .to delegate_to(ConvenientService, :raise)
              end
            end
          end
        end

        example_group "anonymous service class" do
          context "when service has anonymous class" do
            let(:service) do
              Class.new do
                include ConvenientService::Standard::Config

                def result
                  error("message from error")
                end
              end
            end

            specify do
              expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeCalled::Exceptions::ErrorResultIsCalled) { result.call } }
                .to delegate_to(ConvenientService::Utils::Class, :display_name)
                .with_arguments(service)
            end
          end
        end

        example_group "exception handling" do
          example_group "`ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeCalled::Exceptions::ErrorResultIsCalled` exception" do
            let(:rescued) do
              result.call

              false
            rescue ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeCalled::Exceptions::ErrorResultIsCalled
              true
            end

            it "raises exception that can be rescued by `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeCalled::Exceptions::ErrorResultIsCalled`" do
              expect(rescued).to eq(true)
            end
          end

          example_group "`ConvenientService::Result::Exceptions::ErrorResultIsCalled` alias" do
            let(:rescued) do
              result.call

              false
            rescue ConvenientService::Result::Exceptions::ErrorResultIsCalled
              true
            end

            it "raises exception that can be rescued by `ConvenientService::Result::Exceptions::ErrorResultIsCalled` alias" do
              expect(rescued).to eq(true)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
