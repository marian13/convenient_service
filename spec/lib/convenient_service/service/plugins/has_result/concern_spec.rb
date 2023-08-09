# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasResult::Concern do
  let(:service_class) do
    Class.new do
      include ConvenientService::Configs::Minimal
    end
  end

  let(:service_instance) { service_class.new }
  let(:result) { service_instance.result }

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::Matchers::ExtendModule

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
    describe "#result" do
      let(:error_message) do
        <<~TEXT
          Result method (#result) of `#{service_class}` is NOT overridden.
        TEXT
      end

      it "raises `ConvenientService::Service::Plugins::HasResult::Exceptions::ResultIsNotOverridden`" do
        expect { result }
          .to raise_error(ConvenientService::Service::Plugins::HasResult::Exceptions::ResultIsNotOverridden)
          .with_message(error_message)
      end
    end
  end

  example_group "class methods" do
    include ConvenientService::RSpec::Helpers::IgnoringException
    include ConvenientService::RSpec::Matchers::DelegateTo

    let(:service_class) do
      Class.new do
        include ConvenientService::Configs::Minimal

        def result
          success
        end
      end
    end

    describe ".result" do
      specify do
        expect { service_class.result(*args, **kwargs, &block) }
          .to delegate_to(service_class, :new)
          .with_arguments(*args, **kwargs, &block)
      end

      specify do
        allow(service_class).to receive(:new).and_return(service_instance)

        expect { service_class.result(*args, **kwargs, &block) }
          .to delegate_to(service_instance, :result)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
