# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern::InstanceMethods do
  let(:internals_class) do
    Class.new.tap do |klass|
      klass.class_exec(described_class) do |mod|
        include mod
      end
    end
  end

  let(:internals_instance) { internals_class.new }

  example_group "instance methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo
    include ConvenientService::RSpec::Matchers::CacheItsValue

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
