# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Core::InstanceMethods do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:service_instance) { service_class.new }

  describe "#concerns" do
    let(:service_class) do
      Class.new.tap do |klass|
        klass.class_exec(described_class, concerns_result) do |mod, concerns_result|
          include mod

          define_singleton_method(:concerns) { |&block| concerns_result }
        end
      end
    end

    let(:service_instance) { service_class.new }
    let(:concerns_result) { double }
    let(:configuration_block) { proc {} }

    specify {
      expect { service_instance.concerns(&configuration_block) }
        .to delegate_to(service_class, :concerns)
        .with_arguments(&configuration_block)
        .and_return_its_value
    }
  end

  describe "#middlewares" do
    let(:service_class) do
      Class.new.tap do |klass|
        klass.class_exec(described_class, middlewares_result) do |mod, middlewares_result|
          include mod

          define_singleton_method(:middlewares) { |**kwargs, &block| middlewares_result }
        end
      end
    end

    let(:middlewares_result) { double }
    let(:kwargs) { {foo: :bar} }
    let(:configuration_block) { proc {} }

    specify {
      expect { service_instance.middlewares(**kwargs, &configuration_block) }
        .to delegate_to(service_class, :middlewares)
        .with_arguments(**kwargs, &configuration_block)
        .and_return_its_value
    }
  end
end
