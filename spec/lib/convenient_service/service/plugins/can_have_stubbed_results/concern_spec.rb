# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveStubbedResults::Concern, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::CacheItsValue

  let(:service_class) do
    Class.new.tap do |klass|
      klass.class_exec(described_class) do |mod|
        include mod
      end
    end
  end

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::Matchers::ExtendModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { service_class }

      it { is_expected.to extend_module(described_class::ClassMethods) }
    end
  end

  example_group "class methods" do
    describe ".stubbed_results_store" do
      specify do
        expect { service_class.stubbed_results_store }
          .to delegate_to(Thread, :current)
          .without_arguments
          .and_return_its_value
      end
    end

    describe ".stubbed_results" do
      specify do
        expect { service_class.stubbed_results }
          .to delegate_to(ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::FetchServiceStubbedResultsCache, :call)
          .with_arguments(service: service_class)
          .and_return_its_value
      end
    end

    describe ".stub_result" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success
          end
        end
      end

      specify do
        expect { service_class.stub_result }
          .to delegate_to(ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ServiceStub, :new)
          .with_arguments(service_class: service_class)
          .and_return_its_value
      end
    end

    describe ".unstub_result" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success
          end
        end
      end

      specify do
        expect { service_class.unstub_result }
          .to delegate_to(ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ServiceUnstub, :new)
          .with_arguments(service_class: service_class)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
