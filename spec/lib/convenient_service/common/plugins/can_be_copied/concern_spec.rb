# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Common::Plugins::CanBeCopied::Concern do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { service_class }

      let(:service_class) do
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

    let(:service_class) do
      Class.new do
        include ConvenientService::Service::Configs::Standard
      end
    end

    let(:service_instance) { service_class.new(*args, **kwargs, &block) }
    let(:constructor_arguments) { service_instance.constructor_arguments }

    let(:args) { :foo }
    let(:kwargs) { {foo: :bar} }
    let(:block) { proc { :foo } }

    describe "#to_args" do
      specify do
        expect { service_instance.to_args }
          .to delegate_to(service_instance.constructor_arguments, :args)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#to_kwargs" do
      specify do
        expect { service_instance.to_kwargs }
          .to delegate_to(service_instance.constructor_arguments, :kwargs)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#to_block" do
      specify do
        expect { service_instance.to_block }
          .to delegate_to(service_instance.constructor_arguments, :block)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "to_arguments" do
      specify do
        expect { service_instance.to_arguments }
          .to delegate_to(service_instance, :constructor_arguments)
          .without_arguments
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
