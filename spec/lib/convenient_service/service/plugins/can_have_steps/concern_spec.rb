# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Concern, type: :standard do
  include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:service_class) do
    Class.new do
      include ConvenientService::Standard::Config
    end
  end

  let(:service_instance) { service_class.new }

  let(:args) { [Class.new] }
  let(:kwargs) { {in: :foo, out: :bar, container: service_class} }
  let(:step) { service_class.step_class.new(*args, **kwargs.merge(index: 0)) }

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

      it { is_expected.to extend_module(described_class::ClassMethods) }
    end
  end

  example_group "class methods" do
    describe ".raw" do
      let(:value) { :foo }

      specify do
        expect { service_class.raw(value) }
          .to delegate_to(ConvenientService::Support::RawValue, :wrap)
          .with_arguments(value)
          .and_return_its_value
      end
    end

    describe ".step_class" do
      specify do
        expect { service_class.step_class }
          .to delegate_to(ConvenientService::Common::Plugins::CanHaveUserProvidedEntity::Commands::FindOrCreateEntity, :call)
          .with_arguments(namespace: service_class, proto_entity: ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step)
          .and_return_its_value
      end

      specify { expect { service_class.step_class }.to cache_its_value }
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
