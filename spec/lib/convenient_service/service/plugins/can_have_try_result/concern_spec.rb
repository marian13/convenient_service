# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveTryResult::Concern do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:service_class) do
    Class.new do
      include ConvenientService::Configs::Standard
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
    describe "#try_result" do
      let(:error_message) do
        <<~TEXT
          Try result method (#try_result) of `#{service_class}` is NOT overridden.

          NOTE: Make sure overridden `try_result` returns `success` with reasonable "null" data.
        TEXT
      end

      it "raises `ConvenientService::Service::Plugins::CanHaveTryResult::Errors::TryResultIsNotOverridden`" do
        expect { service_instance.try_result }
          .to raise_error(ConvenientService::Service::Plugins::CanHaveTryResult::Errors::TryResultIsNotOverridden)
          .with_message(error_message)
      end
    end
  end

  example_group "class methods" do
    describe ".try_result" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Configs::Standard

          def try_result
            success
          end
        end
      end

      specify do
        expect { service_class.try_result(*args, **kwargs, &block) }
          .to delegate_to(service_class, :new)
          .with_arguments(*args, **kwargs, &block)
      end

      specify do
        allow(service_class).to receive(:new).and_return(service_instance)

        expect { service_class.try_result(*args, **kwargs, &block) }
          .to delegate_to(service_instance, :try_result)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
