# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Common::Plugins::CachesConstructorArguments::Concern, type: :standard do
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

    describe "#constructor_arguments" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Standard::Config
        end
      end

      let(:args) { [:foo] }
      let(:kwargs) { {foo: :bar} }
      let(:block) { proc { :foo } }

      context "when `:initialize` is NOT called" do
        let(:service_instance) { service_class.new_without_initialize }

        specify do
          expect { service_instance.constructor_arguments }
            .to delegate_to(service_instance.internals.cache, :read)
            .with_arguments(:constructor_arguments)
        end

        it "returns null arguments" do
          expect(service_instance.constructor_arguments).to eq(ConvenientService::Support::Arguments.null_arguments)
        end
      end

      context "when `:initialize` is called" do
        let(:service_instance) { service_class.new(*args, **kwargs, &block) }

        specify do
          expect { service_instance.constructor_arguments }
            .to delegate_to(service_instance.internals.cache, :read)
            .with_arguments(:constructor_arguments)
            .and_return_its_value
        end

        it "returns constructor arguments" do
          expect(service_instance.constructor_arguments).to eq(ConvenientService::Support::Arguments.new(*args, **kwargs, &block))
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
