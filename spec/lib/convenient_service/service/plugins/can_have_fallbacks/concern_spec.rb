# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveFallbacks::Concern, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:service_class) do
    Class.new do
      include ConvenientService::Service::Configs::Standard
    end
  end

  let(:service_instance) { service_class.new }

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

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
    describe "#fallback_failure_result" do
      let(:exception_message) do
        <<~TEXT
          Fallback failure result method (#fallback_failure_result) of `#{service_class}` is NOT overridden.

          NOTE: Make sure overridden `fallback_failure_result` returns `success` with reasonable "null" data.
        TEXT
      end

      it "raises `ConvenientService::Service::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden`" do
        expect { service_instance.fallback_failure_result }
          .to raise_error(ConvenientService::Service::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden)
          .with_message(exception_message)
      end

      specify do
        expect { ignoring_exception(ConvenientService::Service::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden) { service_instance.fallback_failure_result } }
          .to delegate_to(ConvenientService, :raise)
      end
    end

    describe "#fallback_error_result" do
      let(:exception_message) do
        <<~TEXT
          Fallback error result method (#fallback_error_result) of `#{service_class}` is NOT overridden.

          NOTE: Make sure overridden `fallback_error_result` returns `success` with reasonable "null" data.
        TEXT
      end

      it "raises `ConvenientService::Service::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden`" do
        expect { service_instance.fallback_error_result }
          .to raise_error(ConvenientService::Service::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden)
          .with_message(exception_message)
      end

      specify do
        expect { ignoring_exception(ConvenientService::Service::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden) { service_instance.fallback_error_result } }
          .to delegate_to(ConvenientService, :raise)
      end
    end
  end

  example_group "class methods" do
    describe ".fallback_failure_result" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Service::Configs::Standard

          def fallback_failure_result
            success
          end
        end
      end

      specify do
        expect { service_class.fallback_failure_result(*args, **kwargs, &block) }
          .to delegate_to(service_class, :new)
          .with_arguments(*args, **kwargs, &block)
      end

      specify do
        allow(service_class).to receive(:new).and_return(service_instance)

        expect { service_class.fallback_failure_result(*args, **kwargs, &block) }
          .to delegate_to(service_instance, :fallback_failure_result)
          .and_return_its_value
      end
    end

    describe ".fallback_error_result" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Service::Configs::Standard

          def fallback_error_result
            success
          end
        end
      end

      specify do
        expect { service_class.fallback_error_result(*args, **kwargs, &block) }
          .to delegate_to(service_class, :new)
          .with_arguments(*args, **kwargs, &block)
      end

      specify do
        allow(service_class).to receive(:new).and_return(service_instance)

        expect { service_class.fallback_error_result(*args, **kwargs, &block) }
          .to delegate_to(service_instance, :fallback_error_result)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
