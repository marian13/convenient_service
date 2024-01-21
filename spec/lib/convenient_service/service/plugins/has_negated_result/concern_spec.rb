# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasNegatedResult::Concern do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:service_class) do
    Class.new do
      include ConvenientService::Service::Configs::Standard

      concerns do
        delete ConvenientService::Service::Plugins::HasNegatedJSendResult::Concern
      end
    end
  end

  let(:service_instance) { service_class.new }
  let(:negated_result) { service_instance.negated_result }

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::PrimitiveMatchers::ExtendModule

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
      it { is_expected.to extend_module(described_class::ClassMethods) }
    end
  end

  example_group "instance methods" do
    describe "#negated_result" do
      let(:exception_message) do
        <<~TEXT
          Negated result method (#negated_result) of `#{service_class}` is NOT overridden.
        TEXT
      end

      it "raises `ConvenientService::Service::Plugins::HasNegatedResult::Exceptions::NegatedResultIsNotOverridden`" do
        expect { negated_result }
          .to raise_error(ConvenientService::Service::Plugins::HasNegatedResult::Exceptions::NegatedResultIsNotOverridden)
          .with_message(exception_message)
      end

      specify do
        expect { ignoring_exception(ConvenientService::Service::Plugins::HasNegatedResult::Exceptions::NegatedResultIsNotOverridden) { negated_result } }
          .to delegate_to(ConvenientService, :raise)
      end
    end
  end

  example_group "class methods" do
    include ConvenientService::RSpec::Helpers::IgnoringException
    include ConvenientService::RSpec::Matchers::DelegateTo

    let(:service_class) do
      Class.new do
        include ConvenientService::Service::Configs::Standard

        concerns do
          delete ConvenientService::Service::Plugins::HasNegatedJSendResult::Concern
        end

        def negated_result
          failure
        end
      end
    end

    describe ".negated_result" do
      specify do
        expect { service_class.negated_result(*args, **kwargs, &block) }
          .to delegate_to(service_class, :new)
          .with_arguments(*args, **kwargs, &block)
      end

      specify do
        allow(service_class).to receive(:new).and_return(service_instance)

        expect { service_class.negated_result(*args, **kwargs, &block) }
          .to delegate_to(service_instance, :negated_result)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
