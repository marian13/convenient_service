# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSequentialSteps::Middleware, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:middleware) { described_class }

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { middleware }

    it { is_expected.to be_descendant_of(ConvenientService::MethodChainMiddleware) }
  end

  example_group "class methods" do
    describe ".intended_methods" do
      let(:spec) do
        Class.new(ConvenientService::MethodChainMiddleware) do
          intended_for :result, entity: :service
        end
      end

      it "returns intended methods" do
        expect(middleware.intended_methods).to eq(spec.intended_methods)
      end
    end
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Helpers::WrapMethod

      subject(:method_value) { method.call }

      let(:method) { wrap_method(service_instance, :result, observe_middleware: middleware) }

      let(:service_instance) { service_class.new }

      context "when service has NO steps" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(middleware) do |middleware|
              include ConvenientService::Standard::Config

              concerns do
                replace \
                  ConvenientService::Service::Plugins::CanHaveConnectedSteps::Concern,
                  ConvenientService::Service::Plugins::CanHaveSequentialSteps::Concern
              end

              middlewares :result do
                replace \
                  ConvenientService::Service::Plugins::CanHaveConnectedSteps::Middleware,
                  middleware

                observe middleware
              end

              def result
                success
              end
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

      context "when service has steps" do
        context "when intermediate step is NOT successful" do
          let(:first_step) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                error
              end
            end
          end

          let(:second_step) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success
              end
            end
          end

          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(first_step, second_step, middleware) do |first_step, second_step, middleware|
                include ConvenientService::Standard::Config

                concerns do
                  replace \
                    ConvenientService::Service::Plugins::CanHaveConnectedSteps::Concern,
                    ConvenientService::Service::Plugins::CanHaveSequentialSteps::Concern
                end

                middlewares :result do
                  replace \
                    ConvenientService::Service::Plugins::CanHaveConnectedSteps::Middleware,
                    middleware

                  observe middleware
                end

                step first_step

                step second_step

                def result
                  success
                end
              end
            end
          end

          it "returns result of intermediate step" do
            expect(method_value).to eq(ConvenientService::Utils::Array.find_last(service_instance.steps, &:evaluated?).result)
          end

          it "returns result with unchecked status" do
            expect(method_value.checked?).to eq(false)
          end

          it "does NOT evaluate results of following steps" do
            expect { method_value }.not_to delegate_to(second_step, :new)
          end

          it "saves intermediate step outputs into organizer" do
            expect { method_value }.to delegate_to(service_instance.steps[0], :save_outputs_in_organizer!).without_arguments
          end

          it "marks intermediate step as completed" do
            expect { method_value }.to change(service_instance.steps[0], :evaluated?).from(false).to(true)
          end

          it "saves step outputs into organizer" do
            expect { method_value }.not_to delegate_to(service_instance.steps[1], :save_outputs_in_organizer!)
          end

          it "does NOT mark following steps as completed" do
            expect { method_value }.not_to change(service_instance.steps[1], :evaluated?).from(false)
          end

          example_group "order of side effects" do
            let(:exception) { Class.new(StandardError) }

            before do
              allow(service_instance.steps[0].status).to receive(:unsafe_not_success?).and_raise(exception)
            end

            it "does NOT save step outputs into organizer before checking status" do
              expect { ignoring_exception(exception) { method_value } }.not_to delegate_to(service_instance.steps[0], :save_outputs_in_organizer!)
            end

            it "does NOT mark intermediate step as completed before checking status" do
              expect { ignoring_exception(exception) { method_value } }.not_to change(service_instance.steps[0], :evaluated?).from(false)
            end
          end
        end

        context "when all steps are successful" do
          let(:first_step) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success
              end
            end
          end

          let(:second_step) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success
              end
            end
          end

          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(first_step, second_step, middleware) do |first_step, second_step, middleware|
                include ConvenientService::Standard::Config

                concerns do
                  replace \
                    ConvenientService::Service::Plugins::CanHaveConnectedSteps::Concern,
                    ConvenientService::Service::Plugins::CanHaveSequentialSteps::Concern
                end

                middlewares :result do
                  replace \
                    ConvenientService::Service::Plugins::CanHaveConnectedSteps::Middleware,
                    middleware

                  observe middleware
                end

                step first_step

                step second_step

                def result
                  success
                end
              end
            end
          end

          it "returns result of last step" do
            expect(method_value).to eq(service_instance.steps[-1].result)
          end

          it "returns result with unchecked status" do
            expect(method_value.checked?).to eq(false)
          end

          it "saves intermediate step outputs into organizer" do
            expect { method_value }
              .to delegate_to(service_instance.steps[0], :save_outputs_in_organizer!)
              .without_arguments
          end

          it "marks intermediate step as completed" do
            expect { method_value }.to change(service_instance.steps[0], :evaluated?).from(false).to(true)
          end

          it "saves last step outputs into organizer" do
            expect { method_value }
              .to delegate_to(service_instance.steps[1], :save_outputs_in_organizer!)
              .without_arguments
          end

          it "marks last step as completed" do
            expect { method_value }.to change(service_instance.steps[1], :evaluated?).from(false).to(true)
          end

          example_group "order of side effects" do
            let(:exception) { Class.new(StandardError) }

            before do
              allow(service_instance.steps[0].status).to receive(:unsafe_not_success?).and_raise(exception)
              allow(service_instance.steps[1].status).to receive(:unsafe_not_success?).and_raise(exception)
            end

            it "does NOT save intermediate step outputs into organizer before checking status" do
              expect { ignoring_exception(exception) { method_value } }.not_to delegate_to(service_instance.steps[0], :save_outputs_in_organizer!)
            end

            it "does NOT mark intermediate step as completed before checking status" do
              expect { ignoring_exception(exception) { method_value } }.not_to change(service_instance.steps[0], :evaluated?).from(false)
            end

            it "does NOT save last step outputs into organizer before checking status" do
              expect { ignoring_exception(exception) { method_value } }.not_to delegate_to(service_instance.steps[1], :save_outputs_in_organizer!)
            end

            it "does NOT mark last step as completed before checking status" do
              expect { ignoring_exception(exception) { method_value } }.not_to change(service_instance.steps[1], :evaluated?).from(false)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
