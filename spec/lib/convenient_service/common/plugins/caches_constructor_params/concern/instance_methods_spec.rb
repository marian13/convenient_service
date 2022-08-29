# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Common::Plugins::CachesConstructorParams::Concern::InstanceMethods do
  example_group "instance methods" do
    # rubocop:disable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration
    let(:service_class) do
      Class.new.tap do |klass|
        klass.class_exec(described_class) do |mod|
          include ConvenientService::Common::Plugins::HasInternals::Concern

          class self::Internals
            include ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
          end

          include mod
        end
      end
    end
    # rubocop:enable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration

    let(:service_instance) { service_class.new }

    describe "#constructor_params" do
      include ConvenientService::RSpec::Matchers::DelegateTo

      ##
      # NOTE: Makes sure that `internals.cache.write(:constructor_params)' returns unique object for test.
      #
      before do
        service_instance.internals.cache.write(:constructor_params, double)
      end

      specify {
        expect { service_instance.constructor_params }
          .to delegate_to(service_instance.internals.cache, :read)
          .with_arguments(:constructor_params)
          .and_return_its_value
      }

      it "returns `cache.read(:constructor_params)'" do
        expect(service_instance.constructor_params).to eq(service_instance.internals.cache.read(:constructor_params))
      end
    end
  end
end
