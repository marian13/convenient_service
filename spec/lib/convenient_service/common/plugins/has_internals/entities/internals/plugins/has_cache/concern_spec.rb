# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern, type: :standard do
  let(:internals_class) do
    Class.new.tap do |klass|
      klass.class_exec(described_class) do |mod|
        include mod
      end
    end
  end

  let(:internals_instance) { internals_class.new }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { internals_class }

      it { is_expected.to include_module(described_class::InstanceMethods) }
    end
  end

  example_group "class methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo
    include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue

    describe ".cache" do
      specify do
        expect { internals_class.cache }
          .to delegate_to(ConvenientService::Support::Cache, :create)
          .with_arguments(backend: :hash)
          .and_return_its_value
      end

      specify do
        expect { internals_class.cache }.to cache_its_value
      end
    end
  end

  example_group "instance methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo
    include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue

    describe "#cache" do
      let(:internals) { internals_instance }

      specify do
        expect { internals.cache }
          .to delegate_to(ConvenientService::Support::Cache, :create)
          .with_arguments(backend: :hash)
          .and_return_its_value
      end

      specify do
        expect { internals.cache }.to cache_its_value
      end
    end
  end
end
