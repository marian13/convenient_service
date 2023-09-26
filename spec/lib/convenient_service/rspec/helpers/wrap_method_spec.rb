# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Helpers::WrapMethod do
  include ConvenientService::RSpec::PrimitiveMatchers::DelegateTo

  example_group "instance methods" do
    describe "#wrap_method" do
      let(:klass) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      let(:instance) { klass.new }

      let(:service_class) do
        Class.new do
          include ConvenientService::Service::Configs::Standard

          middlewares :result do
            observe ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Middleware
          end
        end
      end

      let(:service_instance) { service_class.new }

      let(:entity) { service_instance }
      let(:method) { :result }
      let(:middleware) { ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Middleware }

      specify do
        expect { instance.wrap_method(entity, method, observe_middleware: middleware) }
          .to delegate_to(ConvenientService::RSpec::Helpers::Classes::WrapMethod, :new)
          .with_arguments(entity, method, observe_middleware: middleware)
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
