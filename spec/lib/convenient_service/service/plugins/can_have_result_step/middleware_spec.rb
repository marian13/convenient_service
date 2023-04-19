# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveResultStep::Middleware do
  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::MethodChainMiddleware) }
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Helpers::WrapMethod

      subject(:method_value) { method.call(*args, **kwargs) }

      let(:method) { wrap_method(service_class, :step, middlewares: described_class) }

      let(:args) { [step_service] }
      let(:kwargs) { {container: container, organizer: organizer} }

      let(:service_class) do
        Class.new do
          include ConvenientService::Service::Plugins::CanHaveSteps::Concern
        end
      end

      let(:service_instance) { service_class.new }
      let(:container) { service_class }
      let(:organizer) { service_instance }

      context "when step service is NOT symbol" do
        let(:step_service) { Class.new }

        it "returns original step" do
          expect(method_value).to eq(service_class.step_class.new(*args, **kwargs))
        end
      end

      context "when step service is symbol" do
        let(:step_service) { method_name }

        context "when step service is NOT `:result`" do
          let(:method_name) { :foo }

          let(:error_message) do
            <<~TEXT
              Failed to cast `:#{method_name}` into `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service`.
            TEXT
          end

          it "raises `ConvenientService::Support::Castable::Errors::FailedToCast`" do
            expect { method_value }
              .to raise_error(ConvenientService::Support::Castable::Errors::FailedToCast)
              .with_message(error_message)
          end
        end

        context "when step service is `:result`" do
          let(:method_name) { :result }

          let(:customized_step) do
            service_class.step_class.new(
              ConvenientService::Services::RunOwnMethodInOrganizer,
              in: [
                {method_name: ConvenientService::Support::RawValue.wrap(method_name)},
                {organizer: :itself}
              ],
              container: container,
              organizer: organizer
            )
          end

          it "returns customized step" do
            expect(method_value).to eq(customized_step)
          end

          it "sets step service to `ConvenientService::Services::RunOwnMethodInOrganizer`" do
            expect(method_value.service.klass).to eq(ConvenientService::Services::RunOwnMethodInOrganizer)
          end

          it "concats method name to step inputs" do
            expect(method_value.inputs.find { |input| input.key.to_sym == :method_name }.value).to eq(method_name)
          end

          it "concats organizer to step inputs" do
            expect(method_value.inputs.find { |input| input.key.to_sym == :organizer }.value).to eq(organizer)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
