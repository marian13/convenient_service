# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Middleware do
  include ConvenientService::RSpec::Helpers::IgnoringError

  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::MethodChainMiddleware) }
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Helpers::WrapMethod

      subject(:method_value) { method.call }

      ##
      # TODO: Do not duplicate middleware.
      #
      let(:method) { wrap_method(service_instance, :result, middlewares: described_class) }
      let(:service_instance) { service_class.new }

      context "when service has no steps" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Configs::Standard

            def result
              success
            end
          end
        end

        it "calls super" do
          ##
          # NOTE: Should return success, see how result is defined above.
          #
          expect(method_value).to be_success
        end
      end

      context "when intermediate step is NOT successful" do
        let(:first_step) do
          Class.new do
            include ConvenientService::Configs::Standard

            def result
              error
            end
          end
        end

        let(:second_step) do
          Class.new do
            include ConvenientService::Configs::Standard

            def result
              success
            end
          end
        end

        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(first_step, second_step) do |first_step, second_step|
              include ConvenientService::Configs::Standard

              step first_step

              step second_step

              def result
                success
              end
            end
          end
        end

        it "returns result of intermediate step" do
          expect(method_value).to eq(ConvenientService::Utils::Array.find_last(service_instance.steps, &:completed?).result)
        end

        it "copies result of intermediate step" do
          expect(method_value.object_id).not_to eq(ConvenientService::Utils::Array.find_last(service_instance.steps, &:completed?).result.object_id)
        end

        it "does NOT evaluate results of following steps" do
          expect { method_value }.not_to delegate_to(second_step, :new)
        end

        it "marks intermediate step as completed" do
          expect { method_value }.to change(service_instance.steps[0], :completed?).from(false).to(true)
        end

        it "triggers callback for intermediate step" do
          expect { method_value }
            .to delegate_to(service_instance.steps[0], :trigger_callback)
            .without_arguments
        end

        it "does NOT mark following steps as completed" do
          expect { method_value }.not_to change(service_instance.steps[1], :completed?).from(false)
        end

        it "does NOT trigger callback for following steps" do
          expect { method_value }
            .not_to delegate_to(service_instance.steps[1], :trigger_callback)
            .without_arguments
        end

        example_group "order of side effects" do
          let(:exception) { Class.new(StandardError) }

          before do
            allow(service_instance.steps[0]).to receive(:not_success?).and_raise(exception)
          end

          it "does NOT mark intermediate step as completed before checking status" do
            expect { ignoring_error(exception) { method_value } }.not_to change(service_instance.steps[0], :completed?).from(false)
          end

          it "does NOT trigger callback for intermediate step before checking status" do
            expect { ignoring_error(exception) { method_value } }
              .not_to delegate_to(service_instance.steps[0], :trigger_callback)
              .without_arguments
          end
        end
      end

      context "when all steps are successful" do
        let(:first_step) do
          Class.new do
            include ConvenientService::Configs::Standard

            def result
              success
            end
          end
        end

        let(:second_step) do
          Class.new do
            include ConvenientService::Configs::Standard

            def result
              success
            end
          end
        end

        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(first_step, second_step) do |first_step, second_step|
              include ConvenientService::Configs::Standard

              step first_step

              step second_step

              def result
                success
              end
            end
          end
        end

        it "returns result of last step" do
          expect(method_value).to eq(service_instance.steps.last.result)
        end

        it "copies result of last step" do
          expect(method_value.object_id).not_to eq(service_instance.steps.last.result.object_id)
        end

        it "marks intermediate step as completed" do
          expect { method_value }.to change(service_instance.steps[0], :completed?).from(false).to(true)
        end

        it "triggers callback for intermediate step" do
          expect { method_value }
            .to delegate_to(service_instance.steps[0], :trigger_callback)
            .without_arguments
        end

        it "marks last step as completed" do
          expect { method_value }.to change(service_instance.steps[1], :completed?).from(false).to(true)
        end

        it "triggers callback for last step" do
          expect { method_value }
            .to delegate_to(service_instance.steps[1], :trigger_callback)
            .without_arguments
        end

        example_group "order of side effects" do
          let(:exception) { Class.new(StandardError) }

          before do
            allow(service_instance.steps[0]).to receive(:not_success?).and_raise(exception)
            allow(service_instance.steps[1]).to receive(:not_success?).and_raise(exception)
          end

          it "does NOT mark intermediate step as completed before checking status" do
            expect { ignoring_error(exception) { method_value } }.not_to change(service_instance.steps[0], :completed?).from(false)
          end

          it "does NOT trigger callback for intermediate step before checking status" do
            expect { ignoring_error(exception) { method_value } }
              .not_to delegate_to(service_instance.steps[0], :trigger_callback)
              .without_arguments
          end

          it "does NOT mark last step as completed before checking status" do
            expect { ignoring_error(exception) { method_value } }.not_to change(service_instance.steps[1], :completed?).from(false)
          end

          it "does NOT trigger callback for last step before checking status" do
            expect { ignoring_error(exception) { method_value } }
              .not_to delegate_to(service_instance.steps[1], :trigger_callback)
              .without_arguments
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
