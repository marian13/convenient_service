# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HelpsToLearnSimilaritiesWithCommonObjects::Concern::InstanceMethods, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:service_class) do
    Class.new do
      include ConvenientService::Service::Configs::Essential
      include ConvenientService::Service::Configs::Inspect
      # rubocop:disable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration
      class self::Result
        concerns do
          use ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HelpsToLearnSimilaritiesWithCommonObjects::Concern
        end
      end
      # rubocop:enable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration
    end
  end

  let(:service_instance) { service_class.new }

  let(:result_class) { service_class.result_class }

  let(:result_instance) { result_class.new(**params) }

  let(:params) do
    {
      service: service_instance,
      status: status,
      data: {foo: :bar},
      message: "foo",
      code: :foo
    }
  end

  example_group "instance methods" do
    example_group "conversions" do
      describe "#to_bool" do
        context "when `status` is NOT valid" do
          let(:status) { :foo }

          let(:exception_message) do
            <<~TEXT
              The code that was supposed to be unreachable was executed.

              Unknown result status `#{status}`.
            TEXT
          end

          it "raises `ConvenientService::Support::NeverReachHere`" do
            expect { result_instance.to_bool }
              .to raise_error(ConvenientService::Support::NeverReachHere)
              .with_message(exception_message)
          end

          specify do
            expect { ignoring_exception(ConvenientService::Support::NeverReachHere) { result_instance.to_bool } }
              .to delegate_to(ConvenientService, :raise)
          end
        end

        context "when `status` is valid" do
          context "when `status` is `:success`" do
            let(:status) { :success }

            it "returns `true`" do
              expect(result_instance.to_bool).to eq(true)
            end
          end

          context "when `status` is `:failure`" do
            let(:status) { :failure }

            it "returns `false`" do
              expect(result_instance.to_bool).to eq(false)
            end
          end

          context "when `status` is `:error`" do
            let(:status) { :error }

            let(:exception_message) do
              <<~TEXT
                Error results have no `boolean` representation.

                They are semantically similar to exceptions.
              TEXT
            end

            it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HelpsToLearnSimilaritiesWithCommonObjects::Exceptions::ErrorHasNoOtherTypeRepresentation`" do
              expect { result_instance.to_bool }
                .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HelpsToLearnSimilaritiesWithCommonObjects::Exceptions::ErrorHasNoOtherTypeRepresentation)
                .with_message(exception_message)
            end

            specify do
              expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HelpsToLearnSimilaritiesWithCommonObjects::Exceptions::ErrorHasNoOtherTypeRepresentation) { result_instance.to_bool } }
                .to delegate_to(ConvenientService, :raise)
            end
          end
        end
      end

      describe "#to_object" do
        context "when `status` is NOT valid" do
          let(:status) { :foo }

          let(:exception_message) do
            <<~TEXT
              The code that was supposed to be unreachable was executed.

              Unknown result status `#{status}`.
            TEXT
          end

          it "raises `ConvenientService::Support::NeverReachHere`" do
            expect { result_instance.to_object }
              .to raise_error(ConvenientService::Support::NeverReachHere)
              .with_message(exception_message)
          end

          specify do
            expect { ignoring_exception(ConvenientService::Support::NeverReachHere) { result_instance.to_object } }
              .to delegate_to(ConvenientService, :raise)
          end
        end

        context "when `status` is valid" do
          context "when `status` is `:success`" do
            let(:status) { :success }

            it "returns object" do
              expect(result_instance.to_object).to eq(ConvenientService::Support::Value.new("object"))
            end
          end

          context "when `status` is `:failure`" do
            let(:status) { :failure }

            it "returns nil" do
              expect(result_instance.to_object).to eq(nil)
            end
          end

          context "when `status` is `:error`" do
            let(:status) { :error }

            let(:exception_message) do
              <<~TEXT
                Error results have no `object` representation.

                They are semantically similar to exceptions.
              TEXT
            end

            it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HelpsToLearnSimilaritiesWithCommonObjects::Exceptions::ErrorHasNoOtherTypeRepresentation`" do
              expect { result_instance.to_object }
                .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HelpsToLearnSimilaritiesWithCommonObjects::Exceptions::ErrorHasNoOtherTypeRepresentation)
                .with_message(exception_message)
            end

            specify do
              expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HelpsToLearnSimilaritiesWithCommonObjects::Exceptions::ErrorHasNoOtherTypeRepresentation) { result_instance.to_object } }
                .to delegate_to(ConvenientService, :raise)
            end
          end
        end
      end

      describe "#to_a" do
        context "when `status` is NOT valid" do
          let(:status) { :foo }

          let(:exception_message) do
            <<~TEXT
              The code that was supposed to be unreachable was executed.

              Unknown result status `#{status}`.
            TEXT
          end

          it "raises `ConvenientService::Support::NeverReachHere`" do
            expect { result_instance.to_a }
              .to raise_error(ConvenientService::Support::NeverReachHere)
              .with_message(exception_message)
          end

          specify do
            expect { ignoring_exception(ConvenientService::Support::NeverReachHere) { result_instance.to_a } }
              .to delegate_to(ConvenientService, :raise)
          end
        end

        context "when `status` is valid" do
          context "when `status` is `:success`" do
            let(:status) { :success }

            it "returns array" do
              expect(result_instance.to_a).to eq([ConvenientService::Support::Value.new("item")])
            end
          end

          context "when `status` is `:failure`" do
            let(:status) { :failure }

            it "returns empty array" do
              expect(result_instance.to_a).to eq([])
            end
          end

          context "when `status` is `:error`" do
            let(:status) { :error }

            let(:exception_message) do
              <<~TEXT
                Error results have no `array` representation.

                They are semantically similar to exceptions.
              TEXT
            end

            it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HelpsToLearnSimilaritiesWithCommonObjects::Exceptions::ErrorHasNoOtherTypeRepresentation`" do
              expect { result_instance.to_a }
                .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HelpsToLearnSimilaritiesWithCommonObjects::Exceptions::ErrorHasNoOtherTypeRepresentation)
                .with_message(exception_message)
            end

            specify do
              expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HelpsToLearnSimilaritiesWithCommonObjects::Exceptions::ErrorHasNoOtherTypeRepresentation) { result_instance.to_a } }
                .to delegate_to(ConvenientService, :raise)
            end
          end
        end
      end

      describe "#to_h" do
        context "when `status` is NOT valid" do
          let(:status) { :foo }

          let(:exception_message) do
            <<~TEXT
              The code that was supposed to be unreachable was executed.

              Unknown result status `#{status}`.
            TEXT
          end

          it "raises `ConvenientService::Support::NeverReachHere`" do
            expect { result_instance.to_h }
              .to raise_error(ConvenientService::Support::NeverReachHere)
              .with_message(exception_message)
          end

          specify do
            expect { ignoring_exception(ConvenientService::Support::NeverReachHere) { result_instance.to_h } }
              .to delegate_to(ConvenientService, :raise)
          end
        end

        context "when `status` is valid" do
          context "when `status` is `:success`" do
            let(:status) { :success }

            it "returns hash" do
              expect(result_instance.to_h).to eq({ConvenientService::Support::Value.new("key") => ConvenientService::Support::Value.new("value")})
            end
          end

          context "when `status` is `:failure`" do
            let(:status) { :failure }

            it "returns empty hash" do
              expect(result_instance.to_h).to eq({})
            end
          end

          context "when `status` is `:error`" do
            let(:status) { :error }

            let(:exception_message) do
              <<~TEXT
                Error results have no `hash` representation.

                They are semantically similar to exceptions.
              TEXT
            end

            it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HelpsToLearnSimilaritiesWithCommonObjects::Exceptions::ErrorHasNoOtherTypeRepresentation`" do
              expect { result_instance.to_h }
                .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HelpsToLearnSimilaritiesWithCommonObjects::Exceptions::ErrorHasNoOtherTypeRepresentation)
                .with_message(exception_message)
            end

            specify do
              expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HelpsToLearnSimilaritiesWithCommonObjects::Exceptions::ErrorHasNoOtherTypeRepresentation) { result_instance.to_h } }
                .to delegate_to(ConvenientService, :raise)
            end
          end
        end
      end

      describe "#to_s" do
        context "when `status` is NOT valid" do
          let(:status) { :foo }

          let(:exception_message) do
            <<~TEXT
              The code that was supposed to be unreachable was executed.

              Unknown result status `#{status}`.
            TEXT
          end

          it "raises `ConvenientService::Support::NeverReachHere`" do
            expect { result_instance.to_s }
              .to raise_error(ConvenientService::Support::NeverReachHere)
              .with_message(exception_message)
          end

          specify do
            expect { ignoring_exception(ConvenientService::Support::NeverReachHere) { result_instance.to_s } }
              .to delegate_to(ConvenientService, :raise)
          end
        end

        context "when `status` is valid" do
          context "when `status` is `:success`" do
            let(:status) { :success }

            it "returns string" do
              expect(result_instance.to_s).to eq("string")
            end
          end

          context "when `status` is `:failure`" do
            let(:status) { :failure }

            it "returns empty string" do
              expect(result_instance.to_s).to eq("")
            end
          end

          context "when `status` is `:error`" do
            let(:status) { :error }

            let(:exception_message) do
              <<~TEXT
                Error results have no `string` representation.

                They are semantically similar to exceptions.
              TEXT
            end

            it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HelpsToLearnSimilaritiesWithCommonObjects::Exceptions::ErrorHasNoOtherTypeRepresentation`" do
              expect { result_instance.to_s }
                .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HelpsToLearnSimilaritiesWithCommonObjects::Exceptions::ErrorHasNoOtherTypeRepresentation)
                .with_message(exception_message)
            end

            specify do
              expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HelpsToLearnSimilaritiesWithCommonObjects::Exceptions::ErrorHasNoOtherTypeRepresentation) { result_instance.to_s } }
                .to delegate_to(ConvenientService, :raise)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
