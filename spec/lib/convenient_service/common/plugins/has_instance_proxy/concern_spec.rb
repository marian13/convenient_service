# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Common::Plugins::HasInstanceProxy::Concern do
  let(:concern) { described_class }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::PrimitiveMatchers::ExtendModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { klass }

      let(:klass) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to extend_module(described_class::ClassMethods) }
    end
  end

  example_group "class methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo
    include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue

    describe "#instance_proxy_class" do
      let(:klass) do
        Class.new.tap do |klass|
          klass.class_exec(concern) do |concern|
            include ConvenientService::Core

            concerns do |stack|
              stack.use concern
            end
          end
        end
      end

      specify do
        expect { klass.instance_proxy_class }
          .to delegate_to(ConvenientService::Common::Plugins::HasInstanceProxy::Commands::CreateInstanceProxyClass, :call)
          .with_arguments(namespace: klass)
          .and_return_its_value
      end

      specify do
        expect { klass.instance_proxy_class }.to cache_its_value
      end
    end
  end
end
