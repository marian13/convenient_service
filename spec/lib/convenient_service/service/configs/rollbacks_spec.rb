# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Configs::Rollbacks, type: :standard do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Config) }

    context "when included" do
      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include ConvenientService::Service::Configs::Essential

            include mod
          end
        end
      end

      specify { expect(service_class).to include_module(ConvenientService::Core) }

      example_group "service" do
        example_group ".result middlewares" do
          it "adds `ConvenientService::Service::Plugins::CanHaveRollbacks::Middleware` before `ConvenientService::Service::Plugins::CanHaveConnectedSteps::Middleware` to service step middlewares for `#result`" do
            expect(service_class.middlewares(:result).to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Service::Plugins::CanHaveRollbacks::Middleware || current_middleware == ConvenientService::Service::Plugins::CanHaveConnectedSteps::Middleware }).not_to be_nil
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
